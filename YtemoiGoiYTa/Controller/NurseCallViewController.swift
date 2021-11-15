//
//  NurseCallViewController.swift
//  ytemoiQRCode
//
//  Created by Ta Huy Hung on 29/09/2021.
//

import UIKit
import AVFoundation
import linphonesw

protocol NurseCallDelegate{
    func moveToScreen(_ screenName : String)
}

class NurseCallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,NurseCallDelegate {
    @IBOutlet weak var callNurseBtn: UIButton!
    @IBOutlet weak var imgCallBell: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var bellView: UIView!
    @IBOutlet weak var callCancelView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var imgVolume: UIImageView!
    @IBOutlet weak var btnVolume: UIButton!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var transparentView: UIView!
    
    var mCore: Core!
    var mAccount: Account?
    var mCoreDelegate : CoreDelegate!
    var username : String?
    var passwd : String?
    var domain : String?
    let height: CGFloat = 150
    let screenSize = UIScreen.main.bounds.size
    
    // Incoming call related variables
    var isCallIncoming : Bool = false
    var isCallRunning : Bool = false
    var isSpeakerEnabled : Bool = false
    var isMicrophoneEnabled : Bool = false
    
    var notiPlayer: AVAudioPlayer?
    var ringtonePlayer : AVAudioPlayer?
    var arrButtonTitle = ["Viết đánh giá", "Gửi phản ánh", "Đăng xuất"]
    var rightBarBtnSize : CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initWhenScreenStart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.unregister()
        self.delete()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrButtonTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.btnScreenName.setTitle(arrButtonTitle[indexPath.row], for: .normal)
        cell.screenName = arrButtonTitle[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func moveToScreen(_ screenName : String) {
        if screenName == arrButtonTitle[0] {
            let getReviewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetReviewViewController") as! GetReviewViewController
            self.navigationController?.pushViewController(getReviewVC, animated: true)
        }
        else if screenName == arrButtonTitle[1]{
            let feedbackVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
        else{
            Utils.removeUserInfo()
            let qrScannerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QrScannerViewController") as! QrScannerViewController
            let nav = UINavigationController()
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
            nav.pushViewController(qrScannerVC, animated: true)
        }
    }
    
    @IBAction func callNurseBtnPressed(_ sender: Any) {
        playNotiSound()
        requestSendCallInfoApi()
    }
    
    @IBAction func listenIncommingCallBtnPressed(_ sender: Any) {
        if (self.isCallIncoming) {
            self.acceptCall()
        }
        callView.isHidden = true
    }
    
    @IBAction func cancelIncommingCallBtnPressed(_ sender: Any) {
        self.terminateCall()
    }
    
    @IBAction func onVolumeBtnPressed(_ sender: Any) {
        toggleSpeaker()
        setVolumeLabel()
    }
    
    
    @IBAction func exitMenuTapped(_ sender: Any) {
        transparentView.isHidden = true
        tblMenu.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
            self.transparentView.alpha = 0
            self.tblMenu.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @objc func appMovedToBackground(){
        self.terminateCall()
        self.endRingTone()
    }
    
    private func registerBackgroundEvent(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    private func setVolumeLabel(){
        if isSpeakerEnabled {
            imgVolume.image = UIImage(named: "volume")
        }
        else{
            imgVolume.image = UIImage(named: "ico_mute")
        }
    }
    
    private func requestSendCallInfoApi(){
        let url = "https://ytemoi.com/api/ncb"
        let headers = ["Content-Type" : "application/json"] as [String : String]
        let params = ["id": Utils.getUserInfo().id ?? "",
                      "type":"APPNC_SVG_ButtonSignal_Click",
                      "value": Utils.getUserInfo().sipGlobal ?? ""
        ] as [String : Any]
        
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
            
            //do something
        }
    }
    
    private func initWhenScreenStart(){
        self.title = "Gọi y tá"
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: rightBarBtnSize, height: rightBarBtnSize)
        menuBtn.setImage(UIImage(named:"menu"), for: .normal)
        menuBtn.addTarget(self, action: #selector(onShowMenuPressed), for: UIControl.Event.touchUpInside)
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: rightBarBtnSize)
            currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: rightBarBtnSize)
            currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
        
        tblMenu.delegate = self
        tblMenu.dataSource = self
        transparentView.isHidden = true
        tblMenu.isHidden = true
        username = Utils.getUserInfo().sipGlobal
        passwd = Utils.getUserInfo().sipGlobalPass
        domain = Network.domain
        showBellViewAndComponent()
        linphoneInit()
        registerBackgroundEvent()
    }
    
    @objc func onShowMenuPressed(){
        transparentView.isHidden = false
        tblMenu.isHidden = false
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tblMenu.frame = CGRect(x: 0, y: self.screenSize.height - self.height, width: self.screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    private func linphoneInit(){
        LoggingService.Instance.logLevel = LogLevel.Debug
        
        try? mCore = Factory.Instance.createCore(configPath: "", factoryConfigPath: "", systemContext: nil)
        try? mCore.start()
        
        mCoreDelegate = CoreDelegateStub( onCallStateChanged: { (core: Core, call: Call, state: Call.State, message: String) in
            if (state == .IncomingReceived) { // When a call is received
                self.isCallIncoming = true
                self.isCallRunning = false
                self.playRingTone()
                DispatchQueue.main.async {
                    self.showCallViewAndComponent()
                }
                
            } else if (state == .Connected) { // When a call is over
                self.isCallIncoming = false
                self.isCallRunning = true
                self.endRingTone()
                
            } else if (state == .Released) { // When a call is over
                self.isCallIncoming = false
                self.isCallRunning = false
                self.endRingTone()
                DispatchQueue.main.async {
                    self.terminateCall()
                }
                
            }
        }, onAudioDeviceChanged: { (core: Core, device: AudioDevice) in
            // This callback will be triggered when a successful audio device has been changed
        }, onAudioDevicesListUpdated: { (core: Core) in
            // This callback will be triggered when the available devices list has changed,
            // for example after a bluetooth headset has been connected/disconnected.
        })
        mCore.addDelegate(delegate: mCoreDelegate)
        
        login()
    }
    
    
    func login() {
        do {
            let transport = TransportType.Udp
            let authInfo = try Factory.Instance.createAuthInfo(username: username!, userid: "", passwd: passwd!, ha1: "", realm: "", domain: domain)
            let accountParams = try mCore.createAccountParams()
            let identity = try Factory.Instance.createAddress(addr: String("sip:" + username! + "@" + domain!))
            try! accountParams.setIdentityaddress(newValue: identity)
            let address = try Factory.Instance.createAddress(addr: String("sip:" + domain!))
            try address.setTransport(newValue: transport)
            try accountParams.setServeraddress(newValue: address)
            accountParams.registerEnabled = true
            mAccount = try mCore.createAccount(params: accountParams)
            mCore.addAuthInfo(info: authInfo)
            try mCore.addAccount(account: mAccount!)
            mCore.defaultAccount = mAccount
            
        } catch { NSLog(error.localizedDescription) }
    }
    
    
    func terminateCall() {
        showBellViewAndComponent()
        do {
            // Terminates the call, whether it is ringing or running
            try mCore.currentCall?.terminate()
        } catch { NSLog(error.localizedDescription) }
        self.unregister()
        self.delete()
    }
    
    
    func acceptCall() {
        // IMPORTANT : Make sure you allowed the use of the microphone (see key "Privacy - Microphone usage description" in Info.plist) !
        do {
            // if we wanted, we could create a CallParams object
            // and answer using this object to make changes to the call configuration
            // (see OutgoingCall tutorial)
            try mCore.currentCall?.accept()
        } catch { NSLog(error.localizedDescription) }
    }
    
    func muteMicrophone() {
        // The following toggles the microphone, disabling completely / enabling the sound capture
        // from the device microphone
        mCore.micEnabled = !mCore.micEnabled
        isMicrophoneEnabled = !isMicrophoneEnabled
    }
    
    func toggleSpeaker() {
        // Get the currently used audio device
        let currentAudioDevice = mCore.currentCall?.outputAudioDevice
        let speakerEnabled = currentAudioDevice?.type == AudioDeviceType.Speaker
        
        let _ = currentAudioDevice?.deviceName
        // We can get a list of all available audio devices using
        // Note that on tablets for example, there may be no Earpiece device
        for audioDevice in mCore.audioDevices {
            
            // For IOS, the Speaker is an exception, Linphone cannot differentiate Input and Output.
            // This means that the default output device, the earpiece, is paired with the default phone microphone.
            // Setting the output audio device to the microphone will redirect the sound to the earpiece.
            if (speakerEnabled && audioDevice.type == AudioDeviceType.Microphone) {
                mCore.currentCall?.outputAudioDevice = audioDevice
                isSpeakerEnabled = false
                return
            } else if (!speakerEnabled && audioDevice.type == AudioDeviceType.Speaker) {
                mCore.currentCall?.outputAudioDevice = audioDevice
                isSpeakerEnabled = true
                return
            }
            /* If we wanted to route the audio to a bluetooth headset
             else if (audioDevice.type == AudioDevice.Type.Bluetooth) {
             core.currentCall?.outputAudioDevice = audioDevice
             }*/
        }
    }
    
    func unregister()
    {
        if let account = mCore.defaultAccount {
            let params = account.params
            let clonedParams = params?.clone()
            clonedParams?.registerEnabled = false
            account.params = clonedParams
        }
    }
    
    func delete() {
        if let account = mCore.defaultAccount {
            mCore.removeAccount(account: account)
            mCore.clearAccounts()
            mCore.clearAllAuthInfo()
        }
    }
    
    
    private func showBellViewAndComponent(){
        if mCore != nil {
            login()
        }
        isSpeakerEnabled = false
        setVolumeLabel()
        btnVolume.setTitle("", for: .normal)
        showBellView()
        hideCallView()
        customLabel(title: "CHÚC MỘT NGÀY TỐT LÀNH!", detail: Utils.getUserInfo().name)
        customBellView()
    }
    
    
    private func showCallViewAndComponent(){
        showCallView()
        hideBellView()
        customLabel(title: "Bạn đang có cuộc gọi đến!", detail: "Nhân viên y tế muốn liên lạc với bạn")
    }
    
    
    private func hideBellView(){
        bellView.isHidden = true
    }
    
    private func showBellView(){
        bellView.isHidden = false
    }
    
    private func hideCallView(){
        callCancelView.isHidden = true
    }
    
    private func showCallView(){
        callView.isHidden = false
        callCancelView.isHidden = false
    }
    
    
    private func customLabel(title: String, detail: String){
        lblTitle.text = title
        lblDetail.text = detail
    }
    
    
    private func customBellView(){
        callNurseBtn.layer.cornerRadius = 0.5 * callNurseBtn.bounds.size.width
        callNurseBtn.clipsToBounds = true
        callNurseBtn.setTitle("", for: .normal)
        imgCallBell.image = imgCallBell.image?.withRenderingMode(.alwaysTemplate)
        imgCallBell.tintColor = UIColor.white
    }
    
    
    func playNotiSound() {
        guard let url = Bundle.main.url(forResource: "nursecall_noti", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            notiPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = notiPlayer else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func playRingTone() {
        guard let url = Bundle.main.url(forResource: "ringtone", withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            ringtonePlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = ringtonePlayer else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func endRingTone(){
        if ringtonePlayer != nil {
            ringtonePlayer!.stop()
        }
        
    }
    
}


