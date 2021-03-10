//
//  PaymentModeCell.swift
//  SafexPay
//
//  Created by Sandeep on 8/5/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class PaymentModeCell: UITableViewCell {

    @IBOutlet weak var paymentModeImage: UIImageView!
    @IBOutlet weak var paymentModeLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellView.addShadow(color: UIColor.lightGray)
    }
    
    func setData(mode: paymentModeNew){
        self.paymentModeLabel.text = mode.paymentName
        self.paymentModeImage.image = UIImage(named: mode.payModeID, in: safexBundle, compatibleWith: nil)
    }
    
}
