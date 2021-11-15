//
//  UIViewController.swift
//  ytemoiQRCode
//
//  Created by Ta Huy Hung on 29/09/2021.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showToast(message : String, seconds: Double = 1.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    
    func addDoneButton(to control:UITextField ){
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Xong", style: .done, target: control, action: #selector(UITextField.resignFirstResponder))
        ]
        toolbar.sizeToFit()
        control.inputAccessoryView = toolbar
    }
    
    func addDoneButtonTextView(to control: UITextView ){
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Xong", style: .done, target: control, action: #selector(UITextField.resignFirstResponder))
        ]
        toolbar.sizeToFit()
        control.inputAccessoryView = toolbar
    }
    
}
