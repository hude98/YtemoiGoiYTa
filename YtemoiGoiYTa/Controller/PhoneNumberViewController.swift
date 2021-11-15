//
//  PhoneNumberViewController.swift
//  ytemoiQRCode
//
//  Created by Ta Huy Hung on 30/09/2021.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    @IBOutlet weak var edtPhoneNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDoneButton(to: edtPhoneNumber)
    }
    
    
    @IBAction func goToNextViewBtnPressed(_ sender: Any) {
        if edtPhoneNumber.text == "" {
            showToast(message: "Bạn chưa nhập số điện thoại!")
            return
        }
        requestSendOtpApi()
    }
    
    
    private func requestSendOtpApi(){
        let url = "https://ytemoi.com/api/ncb/app_nc"
        let headers = ["Content-Type" : "application/json"] as [String : String]
        let params = ["loai": Key.appQR,
                      "qrcode": Utils.getQrCodeString(),
                      "sdt": edtPhoneNumber.text!] as [String : Any]
        
        Utils.sendPostRequest(urlString: url,
                              headers: headers,
                              postDictionary: params) { data, response, error in
            
            print("url : \(url)")
            
            if let _ = error {
                print("Error :", error?.localizedDescription ?? "Undefined error")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200  {
                    print("return error: %@", response)
                    return
                }
            }
            
            if data == nil {
                print("No data is found")
                return
            }
            
            
            do {
                let jsonString = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as! String
                let data = jsonString.data(using: .utf8)
                var json: NSDictionary? = nil
                if let data = data {
                    json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? NSDictionary
                }
                let result = json?["ketqua"]
                if result as! String == "Success" {
                    DispatchQueue.main.async {
                        let otpVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OtpViewController") as! OtpViewController
                        otpVC.phoneNumber = self.edtPhoneNumber.text
                        self.navigationController?.pushViewController(otpVC, animated: true)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let message = json?["error"]
                        self.showToast(message: message as! String)
                    }
                }
                
            } catch let error {
                print("Error parsing json: \(error)")
            }
        }
    }
    
    
    
}
        
