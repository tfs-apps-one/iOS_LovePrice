//
//  PriceTagScannerViewModel.swift
//  LovePrice
//
//  AR一発入力モードのスキャンロジック本体。
//  Android版 ArCameraActivity + PriceArAnalyzer に相当する。
//
//  フロー:
//    STEP .productA: 商品Aの値札をスキャン → 金額・容量を認識
//    STEP .productB: 商品Bの値札をスキャン → 金額・容量を認識
//    STEP .completed: 両方完了。呼び出し元へ結果を返す。
//

import Foundation
import AVFoundation
import CoreVideo
import Vision
import UIKit
import Combine

/// AR一発入力のスキャンフェーズ
enum ScanPhase {
    case productA
    case productB
    case completed
}

/// カメラで読み取った価格・容量の最終結果。
/// nil のフィールドは「未取得」を意味する（Android版の -1 に相当）。
struct PriceTagScanResult {
    var priceA: Int?
    var volumeA: Int?
    var priceB: Int?
    var volumeB: Int?
}

/// カメラ利用不可時のエラー種別。手入力フォールバックへ誘導する。
enum PriceTagScannerError: Identifiable {
    case cameraAccessDenied
    case cameraUnavailable

    var id: Int {
        switch self {
        case .cameraAccessDenied: return 0
        case .cameraUnavailable: return 1
        }
    }

    var title: String { "カメラを利用できません" }

    var message: String {
        switch self {
        case .cameraAccessDenied:
            return "カメラのアクセスが許可されていません。設定アプリでカメラへのアクセスを許可するか、価格・容量を手入力してください。"
        case .cameraUnavailable:
            return "カメラを起動できませんでした。価格・容量を手入力してください。"
        }
    }
}

@MainActor
final class PriceTagScannerViewModel: NSObject, ObservableObject {

    // MARK: - UIバインディング用の公開プロパティ

    @Published private(set) var phase: ScanPhase = .productA
    @Published private(set) var boxes: [PriceTagParser.DetectedBox] = []
    /// 向き補正後（正立ポートレート）の解析フレームサイズ。ARオーバーレイの座標変換に使用する。
    @Published private(set) var frameSize: CGSize = .zero

    @Published private(set) var lastPrice: Int?
    @Published private(set) var lastVolume: Int?
    @Published private(set) var priceStability = 0
    @Published private(set) var volumeStability = 0
    @Published private(set) var confirmedPrice: Int?
    @Published private(set) var confirmedVolume: Int?

    @Published private(set) var isReadyOverlayVisible = false
    @Published private(set) var isSamePriceWarningVisible = false
    @Published var scannerError: PriceTagScannerError?

    /// スキャン確定後 or キャンセル時に呼ばれる。nil = キャンセル。
    var onFinished: ((PriceTagScanResult?) -> Void)?

    private(set) var result = PriceTagScanResult()

    // MARK: - 内部定数

    /// 連続何フレーム同じ値を検出したら「確定」とするか
    private let stabilityRequired = 3
    /// STEP A確定後、STEP B開始までの一時停止時間
    private let scanPauseDuration: TimeInterval = 1.0
    /// 同一商品スキャン警告の表示時間
    private let samePriceWarningDuration: TimeInterval = 2.5

    // MARK: - AVCapture
    //
    // カメラセッション関連のプロパティは専用のシリアルキュー(sessionQueue/videoQueue)上でのみ
    // 操作されるため、MainActor分離の対象外(nonisolated)とする。

    private nonisolated let session = AVCaptureSession()
    private nonisolated let videoOutput = AVCaptureVideoDataOutput()
    private nonisolated let sessionQueue = DispatchQueue(label: "tfsapps.loveprice.ar.session")
    private nonisolated let videoQueue = DispatchQueue(label: "tfsapps.loveprice.ar.video")
    /// sessionQueue上でのみ読み書きするため nonisolated(unsafe)。
    private nonisolated(unsafe) var isSessionConfigured = false

    private nonisolated let textRequest: VNRecognizeTextRequest = {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ja-JP", "en-US"]
        request.usesLanguageCorrection = false
        return request
    }()

    private var isScanningPaused = false
    private var isResultFinalized = false
    private var warningWorkItem: DispatchWorkItem?
    private var readyWorkItem: DispatchWorkItem?

    var captureSession: AVCaptureSession { session }

    // MARK: - セットアップ / 破棄

    /// カメラ権限を確認し、OKであればセッションを開始する。
    func start() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSessionIfNeeded()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor in
                    guard let self else { return }
                    if granted {
                        self.configureSessionIfNeeded()
                    } else {
                        self.scannerError = .cameraAccessDenied
                    }
                }
            }
        case .denied, .restricted:
            scannerError = .cameraAccessDenied
        @unknown default:
            scannerError = .cameraUnavailable
        }
    }

    func stop() {
        warningWorkItem?.cancel()
        readyWorkItem?.cancel()
        let session = self.session
        sessionQueue.async {
            if session.isRunning { session.stopRunning() }
        }
    }

    private nonisolated func configureSessionIfNeeded() {
        sessionQueue.async { [weak self] in
            guard let self else { return }
            if self.isSessionConfigured {
                if !self.session.isRunning { self.session.startRunning() }
                return
            }

            self.session.beginConfiguration()
            self.session.sessionPreset = .hd1920x1080

            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  self.session.canAddInput(input) else {
                self.session.commitConfiguration()
                Task { @MainActor in self.scannerError = .cameraUnavailable }
                return
            }
            self.session.addInput(input)

            self.videoOutput.setSampleBufferDelegate(self, queue: self.videoQueue)
            self.videoOutput.alwaysDiscardsLateVideoFrames = true
            if self.session.canAddOutput(self.videoOutput) {
                self.session.addOutput(self.videoOutput)
            }
            // 注: ここでは connection.videoOrientation は設定しない。
            // (OSバージョンによって無視されるケースがあり、それに気づかず
            //  VNImageRequestHandler側の orientation と食い違うとAR枠が90度
            //  回転してしまう。バッファは常にネイティブ(横向き)のまま扱い、
            //  Vision側のorientationパラメータだけで正立に補正する。)

            self.session.commitConfiguration()
            self.isSessionConfigured = true
            self.session.startRunning()
        }
    }

    // MARK: - フレーム検出結果の処理（Android版 onDetected + updateStability 相当）

    private func handleDetection(
        price: Int?,
        volume: Int?,
        boxes: [PriceTagParser.DetectedBox],
        frameSize: CGSize
    ) {
        guard !isResultFinalized, !isScanningPaused else { return }

        self.boxes = boxes
        self.frameSize = frameSize
        updateStability(price: price, volume: volume)
    }

    private func updateStability(price: Int?, volume: Int?) {
        if let price, PriceTagParser.isSimilarValue(price, lastPrice) {
            priceStability += 1
        } else {
            priceStability = price != nil ? 1 : 0
        }
        lastPrice = price

        if let volume, PriceTagParser.isSimilarValue(volume, lastVolume) {
            volumeStability += 1
        } else {
            volumeStability = volume != nil ? 1 : 0
        }
        lastVolume = volume

        if priceStability >= stabilityRequired, confirmedPrice == nil {
            confirmedPrice = lastPrice
        }
        if volumeStability >= stabilityRequired, confirmedVolume == nil {
            confirmedVolume = lastVolume
        }

        // 自動遷移は行わない。価格・容量が確定しても、ユーザーが
        // 「確定」または「スキップ」ボタンを押すまでは同じステップに留まる。
    }

    // MARK: - ステート遷移

    /// 「確定」ボタンタップ時。ユーザーの明示的な操作でのみ次のステップへ進む。
    func confirmCurrentStep() {
        guard confirmedPrice != nil else { return }
        advanceToNextStep()
    }

    private func advanceToNextStep() {
        guard !isResultFinalized else { return }

        switch phase {
        case .productA:
            result.priceA = confirmedPrice
            result.volumeA = confirmedVolume

            isScanningPaused = true
            isReadyOverlayVisible = true

            let work = DispatchWorkItem { [weak self] in
                guard let self else { return }
                self.isReadyOverlayVisible = false
                self.phase = .productB
                self.isScanningPaused = false
                self.resetStepState()
            }
            readyWorkItem = work
            DispatchQueue.main.asyncAfter(deadline: .now() + scanPauseDuration, execute: work)

        case .productB:
            result.priceB = confirmedPrice
            result.volumeB = confirmedVolume

            // 同一商品スキャンチェック（Android版 showSamePriceWarning 相当）
            if let priceA = result.priceA, let priceB = result.priceB,
               PriceTagParser.isSimilarValue(priceB, priceA) {
                showSamePriceWarning()
                return
            }
            finish()

        case .completed:
            break
        }
    }

    private func showSamePriceWarning() {
        isSamePriceWarningVisible = true
        let work = DispatchWorkItem { [weak self] in
            self?.isSamePriceWarningVisible = false
            self?.rescanCurrentStep()
        }
        warningWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + samePriceWarningDuration, execute: work)
    }

    /// 再スキャンボタン。現在ステップの認識結果をクリアして最初からやり直す。
    func rescanCurrentStep() {
        resetStepState()
    }

    /// スキップボタン。未取得(-1相当のnil)のまま次のステップ or 完了へ進む。
    func skipCurrentStep() {
        switch phase {
        case .productA:
            result.priceA = nil
            result.volumeA = nil
            phase = .productB
            resetStepState()
        case .productB:
            result.priceB = nil
            result.volumeB = nil
            finish()
        case .completed:
            break
        }
    }

    private func resetStepState() {
        lastPrice = nil
        lastVolume = nil
        priceStability = 0
        volumeStability = 0
        confirmedPrice = nil
        confirmedVolume = nil
        boxes = []
    }

    private func finish() {
        isResultFinalized = true
        phase = .completed
        stop()
        onFinished?(result)
    }

    /// 閉じるボタン。結果を返さずキャンセルする。
    func cancel() {
        guard !isResultFinalized else { return }
        isResultFinalized = true
        stop()
        onFinished?(nil)
    }

}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension PriceTagScannerViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {

    nonisolated func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        // バッファはセンサーのネイティブ向き（背面カメラを縦持ちで構えると横向き画像として届く）のまま。
        // .right を指定することで、Visionが正立ポートレートとして正しく解析する
        // （＝テキストが横倒しではなく本来の横書きとして認識され、枠の縦横比も正しくなる）。
        let bufferWidth = CVPixelBufferGetWidth(pixelBuffer)
        let bufferHeight = CVPixelBufferGetHeight(pixelBuffer)
        // .right補正後は 幅・高さが入れ替わる（横長バッファ→縦長の正立画像）。
        let frameSize = CGSize(width: bufferHeight, height: bufferWidth)

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        do {
            try handler.perform([textRequest])
        } catch {
            return
        }
        guard let observations = textRequest.results else { return }
        let (price, volume, boxes) = Self.parse(observations: observations)

        Task { @MainActor [weak self] in
            self?.handleDetection(price: price, volume: volume, boxes: boxes, frameSize: frameSize)
        }
    }

    /// OCR結果から金額・容量の最有力候補とAR描画用ボックスを抽出する。
    /// （Android版 PriceArAnalyzer.processResult 相当）
    nonisolated private static func parse(
        observations: [VNRecognizedTextObservation]
    ) -> (price: Int?, volume: Int?, boxes: [PriceTagParser.DetectedBox]) {
        var bestPrice: Int?
        var bestVolume: Int?
        var boxes: [PriceTagParser.DetectedBox] = []

        for observation in observations {
            guard let text = observation.topCandidates(1).first?.string else { continue }

            if let price = PriceTagParser.extractPrice(from: text) {
                if bestPrice == nil || price > bestPrice! { bestPrice = price }
                boxes.append(.init(boundingBox: observation.boundingBox, isPrice: true, value: price))
            }

            if let volume = PriceTagParser.extractVolume(from: text) {
                if bestVolume == nil || volume > bestVolume! { bestVolume = volume }
                boxes.append(.init(boundingBox: observation.boundingBox, isPrice: false, value: volume))
            }
        }

        return (bestPrice, bestVolume, boxes)
    }
}
