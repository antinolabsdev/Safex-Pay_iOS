//
//  EmiViewHeader.swift
//  Safex-Pay
//
//  Created by Sandeep on 30/10/20.
//

import UIKit

protocol EmiViewHeaderProtocol {
    func isEmiSwitchEnabled(state: Bool)
}

class EmiViewHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionTypeLabel: UILabel!
    @IBOutlet weak var sectionExpandButton: UIButton!
    @IBOutlet weak var eppSwitch: UISwitch!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    var delegate: EmiViewHeaderProtocol?
    
    override func awakeFromNib() {}
    
    func setdata(headerLbl:String, isEmiAvailable: Bool){
        self.sectionTypeLabel.text = headerLbl
        if isEmiAvailable{
            self.sectionTypeLabel.textColor = UIColor(hexString: "0058A3")
            self.eppSwitch.isEnabled = true
        }else{
            self.sectionTypeLabel.textColor = UIColor(hexString: "737477")
            self.eppSwitch.isEnabled = false
        }
    }
    
    @IBAction func eppSwitchChanged(_ sender: UISwitch) {
        if sender.isOn{
            self.sectionExpandButton.setImage(UIImage(named: "upside", in: safexBundle, compatibleWith: nil), for: .normal)
            self.subtitleLbl.isHidden = false
            self.delegate?.isEmiSwitchEnabled(state: true)
        }else{
            self.sectionExpandButton.setImage(UIImage(named: "down", in: safexBundle, compatibleWith: nil), for: .normal)
            self.subtitleLbl.isHidden = true
            self.delegate?.isEmiSwitchEnabled(state: false)
        }
    }
    
}
