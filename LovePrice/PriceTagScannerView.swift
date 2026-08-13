//
//  PriceTagScannerView.swift
//  LovePrice
//
//  AR一発入力モードのスキャナー画面。
//  Android版 ArCameraActivity + activity_ar_camera.xml に相当する。
//
//  カメラで商品A → 商品Bの値札を順にスキャンし、価格・容量を自動認識する。
//  読み取りに失敗した場合は「スキップ」ボタンで手入力へフォールバックできる。
//

import SwiftUI
import AVFoundation

struct PriceTagScannerView: View {

    @StateObject private var viewModel = PriceTagScannerViewModel()
    /// fullScreenCover / sheet を閉じるための環境値（iOS14対応のため presentationMode を使用）。
    @Environment(\.presentationMode) private var presentationMode

    /// スキャン終了時に呼ばれる。nil はキャンセル（閉じるボタン / カメラ利用不可）。
    let onFinished: (PriceTagScanResult?) -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            CameraPreviewView(session: viewModel.captureSession)
                .ignoresSafeArea()

            ScanOverlayView(viewModel: viewModel)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerView

                Spacer()

                if viewModel.isReadyOverlayVisible {
                    readyOverlayView
                }

                Spacer()

                footerView
            }

            VStack {
                HStack {
                    Spacer()
                    closeButton
                }
                Spacer()
            }
        }
        .statusBarHidden(true)
        .onAppear {
            // onFinished を呼ぶだけでは画面は閉じない（fullScreenCoverのbinding制御はContentView側）ため、
            // ここで確実に自分自身を閉じる処理までセットで行う。
            viewModel.onFinished = { result in
                onFinished(result)
                presentationMode.wrappedValue.dismiss()
            }
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .alert(item: $viewModel.scannerError) { error in
            Alert(
                title: Text(error.title),
                message: Text(error.message),
                dismissButton: .default(Text("閉じる")) {
                    onFinished(nil)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    // MARK: - ヘッダー

    private var headerView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(stepLabelText)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.7))

            Text(navText)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(navTextColor)

            Text("⚠️ POPの大きな装飾数字は性能上読み取れない場合があります")
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(red: 1, green: 0.27, blue: 0.27))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 16)
        .background(Color.black.opacity(0.87))
        .padding(.top, 44) // セーフエリア(ノッチ)対策
    }

    private var stepLabelText: String {
        switch viewModel.phase {
        case .productA: return "STEP 1 / 2  商品A"
        case .productB, .completed: return "STEP 2 / 2  商品B"
        }
    }

    private var navText: String {
        if viewModel.isSamePriceWarningVisible {
            return "⚠️ 同じ商品をスキャンしていませんか？"
        }
        switch viewModel.phase {
        case .productA: return "商品Aの値札・ラベルを写してください"
        case .productB: return "次に、商品Bを写してください"
        case .completed: return "完了しました"
        }
    }

    private var navTextColor: Color {
        viewModel.isSamePriceWarningVisible ? Color(red: 1, green: 0.55, blue: 0) : .white
    }

    // MARK: - 閉じるボタン

    private var closeButton: some View {
        Button(action: { viewModel.cancel() }) {
            Text("✕ 閉じる")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.87))
        }
        .padding(.top, 58)
        .padding(.trailing, 8)
    }

    // MARK: - STEP切替中オーバーレイ

    private var readyOverlayView: some View {
        VStack(spacing: 20) {
            Text("✅ 商品Aを確定しました")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color(red: 0, green: 0.9, blue: 0.46))

            Text("商品Bの準備をしてください...")
                .font(.system(size: 18))
                .foregroundColor(Color(white: 0.93))

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.4)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.8))
    }

    // MARK: - フッター（操作ボタン + 認識ステータス）

    private var footerView: some View {
        VStack(spacing: 6) {

            // スキップボタン（常時表示）
            Button(action: { viewModel.skipCurrentStep() }) {
                Text(skipButtonText)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white.opacity(0.75))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(red: 0.22, green: 0.28, blue: 0.31).opacity(0.8))
            }
            .padding(.horizontal, 12)

            // 再スキャン + 確定ボタン（金額確定後に出現）
            if viewModel.confirmedPrice != nil {
                HStack(spacing: 6) {
                    Button(action: { viewModel.rescanCurrentStep() }) {
                        Text("🔄 再スキャン")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.08, green: 0.4, blue: 0.75).opacity(0.8))
                    }
                    Button(action: { viewModel.confirmCurrentStep() }) {
                        Text(confirmButtonText)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color(red: 0.18, green: 0.49, blue: 0.2).opacity(0.8))
                    }
                }
                .padding(.horizontal, 12)
            }

            // ステータス表示
            VStack(alignment: .leading, spacing: 8) {
                statusLine(
                    text: priceStatusText,
                    icon: "💴",
                    color: priceStatusColor
                )
                statusLine(
                    text: volumeStatusText,
                    icon: "⚖️",
                    color: volumeStatusColor
                )
                Text(hintText)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.53))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .padding(.bottom, 20)
            .background(Color.black.opacity(0.87))
        }
        .padding(.bottom, 4)
        .background(Color.black.opacity(0.001)) // タップ判定確保用の透明背景
    }

    private func statusLine(text: String, icon: String, color: Color) -> some View {
        Text("\(icon) \(text)")
            .font(.system(size: 19, weight: .bold))
            .foregroundColor(color)
    }

    private var skipButtonText: String {
        viewModel.phase == .productA ? "Aをスキップ ▶B" : "Bをスキップ ✓完了"
    }

    private var confirmButtonText: String {
        viewModel.phase == .productA ? "商品A 確定 ▶" : "商品B 確定 ✓"
    }

    private var priceStatusText: String {
        if let confirmed = viewModel.confirmedPrice {
            return "金額: \(confirmed)円  ✓ 認識完了"
        } else if let last = viewModel.lastPrice {
            return "金額: \(last)円  (\(viewModel.priceStability)/3)"
        } else {
            return "金額: 認識待ち..."
        }
    }

    private var priceStatusColor: Color {
        if viewModel.confirmedPrice != nil { return AppTheme.amber }
        if viewModel.lastPrice != nil { return Color(white: 1).opacity(0.67) }
        return .white.opacity(0.67)
    }

    private var volumeStatusText: String {
        if let confirmed = viewModel.confirmedVolume {
            return "容量: \(confirmed)  ✓ 認識完了"
        } else if let last = viewModel.lastVolume {
            return "容量: \(last)  (\(viewModel.volumeStability)/3)"
        } else {
            return "容量: 認識待ち..."
        }
    }

    private var volumeStatusColor: Color {
        if viewModel.confirmedVolume != nil { return AppTheme.indigo }
        return .white.opacity(0.67)
    }

    private var hintText: String {
        if viewModel.isSamePriceWarningVisible {
            return "2秒後に自動で再スキャンします..."
        }
        return "値札やラベルにカメラを向けてください"
    }
}

#Preview {
    PriceTagScannerView(onFinished: { _ in })
}
