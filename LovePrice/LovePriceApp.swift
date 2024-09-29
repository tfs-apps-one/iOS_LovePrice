//
//  LovePriceApp.swift
//  LovePrice
//
//  Created by 古川貴史 on 2024/09/07.
//

import SwiftUI
import GoogleMobileAds

@main
struct LovePriceApp: App {
    init (){
        //広告初期化
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
