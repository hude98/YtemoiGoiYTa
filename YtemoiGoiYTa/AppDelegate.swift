//
//  AppDelegate.swift
//  YtemoiGoiYTa
//
//  Created by Ta Huy Hung on 07/10/2021.
//

import UIKit
import PushKit
//import Firebase
//import FirebaseMessaging
//import UserNotifications
//import Firebase
//import FirebaseMessaging
//import FirebaseFirestore


@main
//class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate , UNUserNotificationCenterDelegate, MessagingDelegate {
    
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        self.registerForPushNotifications()
        self.handleSwitchScreen()
        return true
    }
    
    private func handleSwitchScreen(){
        //Dòng dưới để test. Sau khi test xong muốn release -> nhớ comment lại
//        Utils.removeUserInfo()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let id = Utils.getUserInfo().id
        if id == nil {
            let rootViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RootNavigationController") as! RootNavigationController
            self.window?.rootViewController = rootViewController
        }
        else{
            let rootViewController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
            self.window?.rootViewController = rootViewController
        }
        self.window?.makeKeyAndVisible()
    }
    
    
//    func applicationWillTerminate(_ application: UIApplication) {
//        print("app bị clear rùi")
//        let nurseCallVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NurseCallViewController") as! NurseCallViewController
//        nurseCallVC.terminateCall()
//    }
    
    
    
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        UserDefaults.standard.setValue(fcmToken, forKey: Key.firebaseFcmToken)
//        print("Firebase registration token: \(fcmToken!)")
//        Utils.setFirebaseRegistrationToken(fcmToken!)
//    }
//
//
//    func registerForPushNotifications() {
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//            // For iOS 10 data message (sent via FCM)
//            //            Messaging.messaging().delegate = self
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//        }
//        UIApplication.shared.registerForRemoteNotifications()
//        updateFirestorePushTokenIfNeeded()
//    }
//
//
//    func updateFirestorePushTokenIfNeeded() {
//        let userID = "currently_logged_in_user_id"
//        if let token = Messaging.messaging().fcmToken {
//            let usersRef = Firestore.firestore().collection("users_table").document(userID)
//            usersRef.setData(["fcmToken": token], merge: true)
//        }
//    }
//
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
//        print(remoteMessage.description)
//    }
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        updateFirestorePushTokenIfNeeded()
//    }
//
//
//    //Hàm application didReceiveRemoteNotification để hiện noti từ api swagger
//    func application(_ application: UIApplication,
//                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        //      if let messageID = userInfo[gcmMessageIDKey] {
//        //        print("Message ID: \(messageID)")
//        //      }
//        //
//        // Print full message.
//        print(userInfo)
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//
//
//
//
//    //Hàm userNotificationCenter để hiện noti trên Firebase
//
//    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // ...
//
//
//        // Print full message.
//        print(userInfo)
//
//        // Change this to your preferred presentation option
//        completionHandler([[.alert, .sound]])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(response)
//        let userInfo = response.notification.request.content.userInfo
//
//        // ...
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler()
//    }
//
//
//
//
//
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
//        print(pushCredentials.token)
//        let deviceToken = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
//        print("pushRegistry -> deviceToken :\(deviceToken)")
//    }
//
//
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("pushRegistry:didInvalidatePushTokenForType:")
//    }
//
//
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
//        print(payload.dictionaryPayload)
//    }
//
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        print("deviceTokenString : \(deviceTokenString)")
//    }
//
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("i am not available in simulator \(error)")
//    }
    
}

