//
//  EmiCellHeader.swift
//  Safex-Pay
//
//  Created by Sandeep on 31/10/20.
//

import UIKit

protocol EmiCellHeaderProtocol {
    func expandSection(tag: Int)
}

class EmiCellHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var AmountLbl: UILabel!
    @IBOutlet weak var ROILbl: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!
    
//    var delegate: EmiCellHeaderProtocol?
    
    override func awakeFromNib() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(expandCell(sender:)))
        self.headerView.addGestureRecognizer(gesture)
    }
    
    func setdata(headerLbl:String, ROI: String){
        self.AmountLbl.text = headerLbl
        self.ROILbl.text = ROI
    }
    
    @objc func expandCell(sender : UITapGestureRecognizer) {
        print("expand this cell \(self.tag)")
//        self.delegate?.expandSection(tag: self.tag)
    }
}
