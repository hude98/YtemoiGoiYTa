//
//  FeedbackViewController.swift
//  YtemoiGoiYTa
//
//  Created by Ta Huy Hung on 23/10/2021.
//

import UIKit

class FeedbackViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var tvTitle: UITextView!
    @IBOutlet weak var tvDetail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWhenScreenAppear()
        loadOldFeedbackApi()
    }
    
    @IBAction func onSendNewFeedBackRequestPressed(_ sender: Any) {
        sendNewFeedbackApi()
    }
    
    
    private func loadOldFeedbackApi(){
        let url = "https://ytemoi.com/api/ncb/app_nc"
        let headers = ["Content-Type" : "application/json"] as [String : String]
        let params = ["loai": Key.loadPhanAnh,
                      "qrcode": Utils.getQrCodeString(),
                      "idbenhnhan": Utils.getUserInfo().id!] as [String : Any]
        
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
            
            do{
                var jsonString = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as! String
                jsonString = jsonString
                    .replacingOccurrences(of: "ObjectId(", with: "")
                    .replacingOccurrences(of: ")", with: "")
                    .replacingOccurrences(of: "ISODate(", with: "")
                let data = jsonString.data(using: .utf8)
                var json: NSDictionary? = nil
                if let data = data {
                    json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? NSDictionary
                }
                let result = json?["ketqua"]
                
                if result as! String == "Success" {
                    let data = json?["data"] as! [String:Any]
                    let dsphananh = data["dsphananh"] as! [[String : Any]]
                    if dsphananh.count == 0{
                        DispatchQueue.main.async {
                            self.tvTitle.text = "Tiêu đề"
                            self.tvDetail.text = "Nội dung"
                        }
                        return
                    }
                    let title = dsphananh[dsphananh.count - 1]["data_phananh_tieude"]
                    let detail = dsphananh[dsphananh.count - 1]["data_phananh_noidung"]
                    DispatchQueue.main.async {
                        self.tvTitle.text = title as? String
                        self.tvDetail.text = detail as? String
                        self.tvTitle.textColor = UIColor.black
                        self.tvDetail.textColor = UIColor.black
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let message = json?["error"]
                        self.showToast(message: message as! String)
                    }
                }
            }
            catch let error {
                print("Error parsing json: \(error)")
            }
            
        }
        
    }
    
    private func sendNewFeedbackApi(){
        let url = "https://ytemoi.com/api/ncb/app_nc"
        let headers = ["Content-Type" : "application/json"] as [String : String]
        let params = ["loai": Key.phanAnh,
                      "qrcode": Utils.getQrCodeString(),
                      "idbenhnhan": Utils.getUserInfo().id!,
                      "tieude" : tvTitle.text ?? "",
                      "noidung" : tvDetail.text ?? "",
                      "diem" : 0] as [String : Any]
        
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
            
            do{
                let jsonString = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as! String
                let data = jsonString.data(using: .utf8)
                var json: NSDictionary? = nil
                if let data = data {
                    json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.fragmentsAllowed) as? NSDictionary
                }
                let result = json?["ketqua"]
                if result as! String == "Success" {
                    print("Success")
                    DispatchQueue.main.async {
                        self.showToast(message: "Đã gửi phản ánh!")
                        self.tvTitle.endEditing(true)
                        self.tvTitle.text = ""
                        self.tvDetail.endEditing(true)
                        self.tvDetail.text = ""
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let message = json?["error"]
                        self.showToast(message: message as! String)
                    }
                }
            }
            catch let error {
                print("Error parsing json: \(error)")
            }
            
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    private func initWhenScreenAppear(){
        tvTitle.delegate = self
        tvDetail.delegate = self
        self.addDoneButtonTextView(to: tvTitle)
        self.addDoneButtonTextView(to: tvDetail)
        tvTitle.text = "Tiêu đề"
        tvTitle.textColor = UIColor.lightGray
        tvDetail.text = "Nội dung"
        tvDetail.textColor = UIColor.lightGray
    }
    
}
