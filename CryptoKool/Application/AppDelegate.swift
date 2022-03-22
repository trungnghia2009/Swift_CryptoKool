//
//  AppDelegate.swift
//  CryptoKool
//
//  Created by trungnghia on 18/02/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CKLog.info(message: "didFinishLaunchingWithOptions...")
        try! FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
        
        do {
            sleep(1)
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        /*
         <scheme>://<host>
         cryptoKool://home
         cryptoKool://search
         */
        
        // Process the URL
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host
        else {
            CKLog.error(message: "Invalid URL")
            return false
        }
        
        CKLog.info(message: "Components: \(components)")
        
        // Create the deep link
        guard let deepLink = DeepLink(rawValue: host) else {
            CKLog.error(message: "Deeplink not found: \(host)")
            return false
        }
        
        // Hand off to mainViewController
        switch deepLink {
        case .home:
            break
        case .search:
            PresenterManager.shared.show(vc: .informationScreen)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

