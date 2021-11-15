//
//  MainViewController.swift
//  YtemoiGoiYTa
//
//  Created by Ta Huy Hung on 25/10/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nurseCallVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NurseCallViewController") as! NurseCallViewController
        let childNavigation = UINavigationController(rootViewController: nurseCallVC)
        childNavigation.willMove(toParent: self)
        addChild(childNavigation)
        childNavigation.view.frame = view.frame
        view.addSubview(childNavigation.view)
        childNavigation.didMove(toParent: self)
    }
    
    
}
