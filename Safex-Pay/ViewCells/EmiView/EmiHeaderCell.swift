//
//  EmiHeaderCell.swift
//  Safex-Pay
//
//  Created by Sandeep on 31/10/20.
//

import UIKit

class EmiHeaderCell: UITableViewCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var AmountLbl: UILabel!
    @IBOutlet weak var ROILbl: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setdata(amount:String, numOfMonths: String, ROI: String, img: String){
        self.AmountLbl.text = "\(currencyCode) \(amount) for \(numOfMonths) months"
        self.ROILbl.text = "\(ROI) % p.a."
    }
    
    func setSelectionImg(isExpanded: Bool){
        if isExpanded{
            self.selectionImg.image = UIImage(named: "Selected_Radio", in: safexBundle, compatibleWith: nil)
        }else{
            self.selectionImg.image = UIImage(named: "Unselected_Radio", in: safexBundle, compatibleWith: nil)
        }
    }
}
