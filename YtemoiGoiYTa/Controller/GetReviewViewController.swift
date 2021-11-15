//
//  GetReviewViewController.swift
//  YtemoiGoiYTa
//
//  Created by Ta Huy Hung on 23/10/2021.
//

import UIKit

class GetReviewViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var tvReview: UITextView!
    @IBOutlet weak var imgStar1: UIImageView!
    @IBOutlet weak var imgStar2: UIImageView!
    @IBOutlet weak var imgStar3: UIImageView!
    @IBOutlet weak var imgStar4: UIImageView!
    @IBOutlet weak var imgStar5: UIImageView!
    var arrImageView = [UIImageView]()
    var arrID = [String]()
    var numberOfStars = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initWhenScreenAppear()
        loadOldReviewApi()
    }
    
    @IBAction func onStar1Pressed(_ sender: Any) {
        numberOfStars = 1
        checkStar(numberOfStars)
    }
    
    @IBAction func onStar2Pressed(_ sender: Any) {
        numberOfStars = 2
        checkStar(numberOfStars)
    }
    
    @IBAction func onStar3Pressed(_ sender: Any) {
        numberOfStars = 3
        checkStar(numberOfStars)
    }
    
    @IBAction func onStar4Pressed(_ sender: Any) {
        numberOfStars = 4
        checkStar(numberOfStars)
    }
    
    @IBAction func onStar5Pressed(_ sender: Any) {
        numberOfStars = 5
        checkStar(numberOfStars)
    }
    
    
    @IBAction func onSendReviewRequestPressed(_ sender: Any) {
        if arrID.count == 0 {
            sendNewReviewApi()
        }
        else{
            updateReviewApi()
        }
    }
    
    private func loadOldReviewApi(){
        let url = "https://ytemoi.com/api/ncb/app_nc"
        let headers = ["Content-Type" : "application/json"] as [String : String]
        let params = ["loai": Key.loadDanhGia,
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
                    let dsdanhgia = data["dsdanhgia"] as! [[String : Any]]
                    if dsdanhgia.count == 0 {
                        DispatchQueue.main.async {
                            self.tvReview.text = "Đánh giá"
                            self.resetStar()
                        }
                        return
                    }
                    for i in 0...dsdanhgia.count - 1 {
                        self.arrID.append(dsdanhgia[i]["_id"] as! String)
                    }
                    let detail = dsdanhgia[dsdanhgia.count - 1]["data_danhgia_noidung"] as! String
                    let diem = dsdanhgia[dsdanhgia.count - 1]["data_danhgia_diem"] as! Int
                    DispatchQueue.main.async {
                        self.tvReview.text = detail
                        self.tvReview.textColor = UIColor.black
                        self.numberOfStars = diem
                        self.checkStar(self.numberOfStars)
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
    
    
    private func updateReviewApi(){
        let url = "https://ytemoi.com/api/ncb/app_nc"
        let headers = ["Content-Type" : "application/json"] as [String : String]
        let params = ["loai": Key.updateDanhGia,
                      "qrcode": Utils.getQrCodeString(),
                      "idbenhnhan": Utils.getUserInfo().id!,
                      "tieude" : "",
                      "noidung" : tvReview.text ?? "",
                      "diem" : numberOfStars,
                      "id" : arrID[arrID.count - 1]] as [String : Any]
        
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
                        self.showToast(message: "Đã gửi đánh giá!")
                        self.tvReview.endEditing(true)
                        self.tvReview.text = ""
                        self.resetStar()
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
    
    private func sendNewReviewApi(){
        let url = "https://ytemoi.com/api/ncb/app_nc"
        let headers = ["Content-Type" : "application/json"] as [String : String]
        let params = ["loai": Key.danhGia,
                      "qrcode": Utils.getQrCodeString(),
                      "idbenhnhan": Utils.getUserInfo().id!,
                      "tieude" : "",
                      "noidung" : tvReview.text ?? "",
                      "diem" : numberOfStars] as [String : Any]
        
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
                        self.showToast(message: "Đã gửi đánh giá!")
                        self.tvReview.endEditing(true)
                        self.tvReview.text = ""
                        self.resetStar()
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
    
    private func checkStar(_ numberOfStars : Int){
        var i = 0
        while i < arrImageView.count {
            while i < numberOfStars {
                arrImageView[i].image = UIImage(named: "star_checked")
                i += 1
            }
            if i == arrImageView.count {
                break
            }
            arrImageView[i].image = UIImage(named: "star_not_check")
            i += 1
        }
    }
    
    private func initWhenScreenAppear(){
        tvReview.delegate = self
        self.addDoneButtonTextView(to: tvReview)
        tvReview.text = "Đánh giá"
        tvReview.textColor = UIColor.lightGray
        resetStar()
        arrImageView.append(imgStar1)
        arrImageView.append(imgStar2)
        arrImageView.append(imgStar3)
        arrImageView.append(imgStar4)
        arrImageView.append(imgStar5)
    }
    
    private func resetStar(){
        imgStar1.image = UIImage(named: "star_not_check")
        imgStar2.image = UIImage(named: "star_not_check")
        imgStar3.image = UIImage(named: "star_not_check")
        imgStar4.image = UIImage(named: "star_not_check")
        imgStar5.image = UIImage(named: "star_not_check")
    }
    
    
}
