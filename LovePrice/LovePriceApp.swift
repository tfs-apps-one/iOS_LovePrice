//
//  LovePriceApp.swift
//  LovePrice
//
//  Created by 古川貴史 on 2024/09/07.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct LovePriceApp: App {
    init (){
        //広告初期化
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    requestTrackingAuthorizationIfNeeded()
                }
        }
    }

    /**************************************************
     * ATT（App Tracking Transparency）許可リクエスト
     *  広告SDK(AdMob)がIDFAをトラッキング目的で利用するため、
     *  Appleの規定により事前にユーザーへ許可を求める必要がある。
     *  App Privacyで「トラッキングに使用されるデータ」を申告している場合、
     *  このリクエストの実装は必須。
     *************************************************/
    private func requestTrackingAuthorizationIfNeeded() {
        // 起動直後は許可ダイアログが表示されないことがあるため、少し遅延させる。
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                // 許可状態に応じて、Google Mobile Ads SDK側がIDFA利用可否を自動的に判定する。
            }
        }
    }
}
