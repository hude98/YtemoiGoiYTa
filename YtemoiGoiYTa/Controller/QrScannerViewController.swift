//
//  QrScannerViewController.swift
//  ytemoiQRCode
//
//  Created by Ta Huy Hung on 29/09/2021.
//

import UIKit
import AVFoundation

class QrScannerViewController: UIViewController, QRScannerViewDelegate {
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        Utils.setQrCodeString(str!)
        print("\n QRCode : \(str!) \n")
        scannerView.stopScanning()
        let phoneNumberVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PhoneNumberViewController") as! PhoneNumberViewController
        self.navigationController?.pushViewController(phoneNumberVC, animated: true)
    }
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }
    
    
}



