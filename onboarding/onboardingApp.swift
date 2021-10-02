//
//  onboardingApp.swift
//  onboarding
//
//  Created by Кирилл on 26.08.2021.
//

import SwiftUI
import ApphudSDK
import UserNotifications

@main
struct onboardingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var viewRouter = ViewRouter()
    var body: some Scene {
        WindowGroup {
            MotherView(viewRouter: viewRouter)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //Apphud.enableDebugLogs()
        Apphud.start(apiKey: "app_77HzUza2KmUMp7saTyiBiGmjtCUnpY")
        registerForNotifications()
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Apphud.submitPushNotificationsToken(token: deviceToken, callback: nil)
    }
}

func registerForNotifications(){
   // UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])    { (granted, error) in
        // handle if needed
    }
    UIApplication.shared.registerForRemoteNotifications()
    let content = UNMutableNotificationContent()
    content.title = "Get Clean Sound!" 
    content.sound = UNNotificationSound.default

    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4 * 3600, repeats: true)

    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    // add our notification request
    if (!Apphud.hasActiveSubscription())
    {
        UNUserNotificationCenter.current().add(request)
    }
}


