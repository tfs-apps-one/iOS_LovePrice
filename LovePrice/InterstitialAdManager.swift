//
//  InterstitialAdManager.swift
//  LovePrice
//
//  ARスキャンボタンを7回タップするごとに全面広告(インタースティシャル)を1回表示するための管理クラス。
//  Android版にはない、iOS版独自の追加機能。
//  タップ回数自体は ContentView 側で @AppStorage により永続化しており、
//  アプリを終了して再起動しても前回の続きからカウントされる。
//
//  広告ユニットIDは動作確認用に、Googleが提供するテスト広告のユニットID
//  (ca-app-pub-3940256099942544/4411468910) を設定しています。
//  本番リリース時は、AdMob管理画面で発行した本番用の広告ユニットIDに置き換えてください。
//

import Foundation
import GoogleMobileAds
import UIKit

@MainActor
final class InterstitialAdManager: NSObject, ObservableObject {

    // 全面広告のテスト広告ユニットID。
    // 本番運用時は AdMob 管理画面で発行した専用のユニットIDに差し替えること。
//    private let adUnitID = "ca-app-pub-3940256099942544/4411468910" //テストID
    private let adUnitID = "ca-app-pub-4924620089567925/8268854283" //本番ID

    private var interstitialAd: GADInterstitialAd?
    private var onAdClosed: (() -> Void)?

    override init() {
        super.init()
        loadAd()
    }

    /// 広告をあらかじめ読み込んでおく（表示直前の待ち時間を減らすため）。
    func loadAd() {
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] ad, error in
            guard let self else { return }
            if let error {
                print("インタースティシャル広告の読み込みに失敗: \(error.localizedDescription)")
                self.interstitialAd = nil
                return
            }
            self.interstitialAd = ad
            self.interstitialAd?.fullScreenContentDelegate = self
        }
    }

    /// 全面広告を表示する。広告が準備できていない場合は体験を止めずに即座に completion を呼ぶ。
    func showAd(completion: @escaping () -> Void) {
        guard let interstitialAd,
              let rootViewController = UIApplication.shared.lovePrice_currentRootViewController else {
            completion()
            loadAd()
            return
        }
        onAdClosed = completion
        interstitialAd.present(fromRootViewController: rootViewController)
    }
}

extension InterstitialAdManager: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("インタースティシャル広告の表示に失敗: \(error.localizedDescription)")
        interstitialAd = nil
        onAdClosed?()
        onAdClosed = nil
        loadAd()
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitialAd = nil
        onAdClosed?()
        onAdClosed = nil
        // 次回の表示に備えて、次の広告をあらかじめ読み込んでおく。
        loadAd()
    }
}

private extension UIApplication {
    var lovePrice_currentRootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
