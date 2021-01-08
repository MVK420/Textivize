//
//  InterstitialAd.swift
//  Textivize
//
//  Created by Mozes Vidami on 1/9/21.
//

import SwiftUI
import GoogleMobileAds

class InterstitialService: NSObject, GADInterstitialDelegate, ObservableObject {
    
    var interstitialAd: GADInterstitial? = nil
    @Published var isLoaded: Bool = false
    
    func loadInterstitial() {
        interstitialAd = GADInterstitial(adUnitID: Constants.interstitialAdCode)
        let req = GADRequest()
        interstitialAd!.load(req)
        interstitialAd!.delegate = self
    }
    
    func showAd() -> Bool {
        if let interstitialAd = self.interstitialAd, interstitialAd.isReady {
            let root = UIApplication.shared.windows.first?.rootViewController
            interstitialAd.present(fromRootViewController: root!)
            isLoaded = false
            //print("Showing Ad")
            return true
        }
        return false
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        //print("ad loaded")
        isLoaded = true
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        //print("user clicked ad")
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        //print("Dismissed ad")
        NotificationCenter.default.post(name: NSNotification.canSaveImage,
            object: nil, userInfo: nil)
    }
}

extension NSNotification {
    static let canSaveImage = NSNotification.Name.init("Ad Dismissed")
}
