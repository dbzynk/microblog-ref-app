//
//  HiPlaceApp.swift
//  HiPlace
//
//  Created by Ali Mert Özhayta on 31.05.2021.
//

import SwiftUI
import AGConnectCore
import HmsPushSdk
import HiAnalytics

@main
struct HiPlaceApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
  
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AuthService.shared)
        }
    }
}

//*** Implement App delegate ***//
class AppDelegate: NSObject, UIApplicationDelegate {
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupAppGalleryConnect()
        return true
    }
//No callback in simulator
//-- must use device to get valid push token
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if targetEnvironment(simulator)
            print("DEBUG:: It's an iOS Simulator")
        #else
            getPushToken(deviceToken)
        #endif
     }
    
     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DEBUG:: \(error.localizedDescription)")
    }
}

private extension AppDelegate {

    func setupAppGalleryConnect() {
        AGCInstance.startUp()

        var error: NSError? = nil
        AGConnectCloudDB.initEnvironment(&error)
        if let error = error {
            print("DEBUG:: initEnvironment: \(error.debugDescription)")
        }
        
        var createError: NSError? = nil
        if let error = createError {
            print("DEBUG:: createObjectType: \(error.debugDescription)")
        }

        AGConnectCloudDB.shareInstance().createObjectType(AGCCloudDBObjectTypeInfoHelper.obtainObjectTypeInfo(), error: &createError)
        AGConnectCloudDB.shareInstance().enableNetwork(CloudDBHelper.zoneName)
        setupPush()
        
        HiAnalytics.config()
    }
    
    func setupPush() {
        // Request the message push permission.
               UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) {
                       accepted, _ in
                       if !accepted {
                           print("user not allow to display")
                       }
                   }
               // Request a token from the APNs.
               UIApplication.shared.registerForRemoteNotifications()
    }
    
    func getPushToken(_ deviceToken: Data) {
        // Check the iOS version.
        var deviceTokenString = ""
        if #available(iOS 13.0, *)  {
            var deviceTokenString1 = String()
            let bytes = [UInt8](deviceToken)
            for item in bytes {
                deviceTokenString1 += String(format: "%02x", item & 0x000000FF)
            }
            print(">=ios 13 deviceToken:\(deviceTokenString1)")
            deviceTokenString = deviceTokenString1;
        } else {
            deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
            print("< ios 13, device token  is  :  \(deviceTokenString)")
        }

        huaweiToken = HmsInstanceId.getInstance().getToken(deviceTokenString)
        print("DEBUG:: deviceTokenString: \(deviceTokenString)")
        print("DEBUG:: huaweiToken: \(huaweiToken ?? "nil")")

    }
}

