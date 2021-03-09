//
//  EmiCell.swift
//  Safex-Pay
//
//  Created by Sandeep on 31/10/20.
//

import UIKit

class EmiCell: UITableViewCell {
    
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var interestLbl: UILabel!
    @IBOutlet weak var feesLbl: UILabel!
    @IBOutlet weak var totalbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(order: String, interest: String, fees: String, total: String){
        self.orderLbl.text = order
        self.interestLbl.text = interest
        self.feesLbl.text = fees
        self.totalbl.text = total
    }
    
    func setData(data: Epp){
        self.orderLbl.text = data.amount
        self.interestLbl.text = data.interest
        self.feesLbl.text = data.processingFees
        self.totalbl.text = data.totalAmount
    }
}
