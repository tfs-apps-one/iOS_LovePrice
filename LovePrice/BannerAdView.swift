//
//  BannerAdView.swift
//  LovePrice
//
//  Created by 古川貴史 on 2024/09/28.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
    #if false //test_make
        let viewController = UIViewController()
    #else
        let viewController = UIViewController()
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        
//        banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"  //テスト広告
        banner.adUnitID = "ca-app-pub-4924620089567925/9333266470"  //本番 ここにあなたの広告ユニットIDを入れます
        banner.rootViewController = viewController
        
        viewController.view.addSubview(banner)
        
        banner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            banner.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
        
        banner.load(GADRequest())
    #endif
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
