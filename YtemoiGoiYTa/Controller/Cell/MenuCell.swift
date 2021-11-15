//
//  MenuCell.swift
//  YtemoiGoiYTa
//
//  Created by Ta Huy Hung on 23/10/2021.
//

import UIKit

class MenuCell: UITableViewCell {
    var delegate : NurseCallDelegate?
    var screenName = ""
    
    @IBOutlet weak var btnScreenName: UIButton!
    
    @IBAction func onChooseScreenPressed(_ sender: Any) {
        delegate?.moveToScreen(screenName)
    }
    
}
