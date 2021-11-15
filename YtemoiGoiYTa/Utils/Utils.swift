//
//  Utils.swift
//  ytemoiQRCode
//
//  Created by Ta Huy Hung on 05/10/2021.
//

import UIKit

class Utils: NSObject {
    class func sendPostRequest(urlString: String,
                               headers: [String:String],
                               postDictionary: [String:Any],
                               completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: postDictionary, options: .fragmentsAllowed) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                for (key, value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
                request.httpMethod = "POST"
                request.httpBody = jsonData
                let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
                task.resume()
                
            } else {
                print("could not open url, it was nil")
            }
        }
    }
    
    
    //User info
    class func setUserInfo(_ user : User){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: Key.user)
        }
    }
    
    class func getUserInfo() -> User{
        if let user = UserDefaults.standard.object(forKey: Key.user) as? Data {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(User.self, from: user) {
                return decoded
            }
        }
        return User()
    }
    
    class func removeUserInfo(){
        UserDefaults.standard.removeObject(forKey: Key.user)
    }
    
    
    
    //qr code
    class func setQrCodeString(_ qrcode : String){
        UserDefaults.standard.set(qrcode, forKey: Key.QRCodeString)
    }
    
    class func getQrCodeString() -> String{
        return UserDefaults.standard.string(forKey: Key.QRCodeString) ?? ""
    }
    
    class func removeQrCodeString(){
        UserDefaults.standard.removeObject(forKey: Key.QRCodeString)
    }
    
    
    
    //window
    class func getMainWindow() -> UIWindow? {
        if(getOsVersion() >= 13) {
            return UIApplication.shared.windows.filter({$0.isKeyWindow}).first
        }
        else {
            return UIApplication.shared.delegate?.window ?? nil
        }
    }
    
    class func getOsVersion() -> Int {
        let systemVersion = UIDevice.current.systemVersion
        return (systemVersion as NSString).integerValue
    }
    
    
    
    //FIREBASE REGISTRATION TOKEN
    class func setFirebaseRegistrationToken(_ fcm : String) {
        UserDefaults.standard.set(fcm, forKey: Key.firebaseFcmToken)
    }

    class func getFirebaseRegistrationToken() -> String{
        return UserDefaults.standard.string(forKey: Key.firebaseFcmToken) ?? ""
    }
    
    class func removeFirebaseRegistrationToken(){
        UserDefaults.standard.removeObject(forKey: Key.firebaseFcmToken)
    }
    
    
}
