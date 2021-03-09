//
//  AddCardCell.swift
//  SafexPay
//
//  Created by Sandeep on 8/17/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
import RSSelectionMenu

protocol AddCardCellProtocol {
    func checkEmi(cardNum: String)
    func cardNumber(cardNum: String)
    func cardName(cardName: String)
    func cardExpMonth(expMonth: String)
    func cardExpYear(expYear: String)
    func cardCvv(cvv: String)
}

class AddCardCell: UITableViewCell {

    @IBOutlet weak var cardNumTxtFld: UnderLineImageTextField!
    @IBOutlet weak var cardNumView: UIView!
    @IBOutlet weak var cardNameTxtFld: UITextField!
    @IBOutlet weak var cardNameView: UIView!
    @IBOutlet weak var expiryMonthView: UIView!
    @IBOutlet weak var expiryMonthLbl: UILabel!
    @IBOutlet weak var expiryYearView: UIView!
    @IBOutlet weak var expiryYearLbl: UILabel!
    @IBOutlet weak var cvvTxtFld: UITextField!
    @IBOutlet weak var cvvView: UIView!
    @IBOutlet weak var saveCardBtn: UIButton!
    @IBOutlet weak var cardTypeImage: UIImageView!
    @IBOutlet weak var tickBoxImg: UIImageView!
    
    var delegate: AddCardCellProtocol?
    var view = UIViewController()
    var shouldSaveCard = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardNumView.addBorders(edges: .all, color: UIColor.lightGray)
        self.cardNameView.addBorders(edges: .all, color: UIColor.lightGray)
        self.cvvView.addBorders(edges: .all, color: UIColor.lightGray)
        self.expiryYearView.addBorders(edges: .all, color: UIColor.lightGray)
        self.expiryMonthView.addBorders(edges: .all, color: UIColor.lightGray)
        self.cardNumTxtFld.delegate = self
        self.cardNameTxtFld.delegate = self
        self.cvvTxtFld.delegate = self
        self.cardNumTxtFld.addTarget(self, action: #selector(self.textDidChange(textField:)), for: .editingChanged)
        let monthGesture = UITapGestureRecognizer(target: self, action: #selector(selectMonthAction(sender:)))
        self.expiryMonthView.addGestureRecognizer(monthGesture)
        let yearGesture = UITapGestureRecognizer(target: self, action: #selector(selectYearAction(sender:)))
        self.expiryYearView.addGestureRecognizer(yearGesture)
    }
    
    @IBAction func saveCardPressed(_ sender: UIButton) {
        if shouldSaveCard{
            shouldSaveCard = false
            self.tickBoxImg.image = UIImage(named: "tickedbox", in: safexBundle, compatibleWith: nil)
        }else{
            shouldSaveCard = true
            self.tickBoxImg.image = UIImage(named: "tickbox", in: safexBundle, compatibleWith: nil)
        }
        
    }
    
    @objc func selectMonthAction(sender : UITapGestureRecognizer) {
        self.endEditing(true)
        let months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: months) { (cell, data, index) in
            cell.textLabel?.text = data
        }
        let selectedItems = [String]()
        selectionMenu.setSelectedItems(items: selectedItems) { (text, index, selected, selectedItems) in
            if let selectedMonth = text {
                self.expiryMonthLbl.text = "Expiry date : \(selectedMonth)"
                self.delegate?.cardExpMonth(expMonth: selectedMonth)
            }
        }
        selectionMenu.cellSelectionStyle = .tickmark
        selectionMenu.showEmptyDataLabel(text: "No Data Found")
        selectionMenu.show(style: .alert(title: "Select month", action: "Done", height: nil), from: view)
    }
    
    @objc func selectYearAction(sender : UITapGestureRecognizer) {
        self.endEditing(true)
        var years = [Int]()
        for year in 2020...2045{
            years.append(year)
        }
        let selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: years) { (cell, data, index) in
            cell.textLabel?.text = String(data)
        }
        let selectedItems = [Int]()
        selectionMenu.setSelectedItems(items: selectedItems) { (text, index, selected, selectedItems) in
            if let selectedYear = text {
                self.expiryYearLbl.text = "Expiry date : \(selectedYear)"
                self.delegate?.cardExpYear(expYear: String(selectedYear))
            }
        }
        selectionMenu.cellSelectionStyle = .tickmark
        selectionMenu.showEmptyDataLabel(text: "No Data Found")
        selectionMenu.show(style: .alert(title: "Select year", action: "Done", height: nil), from: view)
    }
    
}

extension AddCardCell: UITextFieldDelegate{
    @objc func textDidChange(textField: UITextField) {
        textField.text = modifyCreditCardString(creditCardString: textField.text!)
        if let cardNum = textField.text, cardNum.count < 7{
            self.cardTypeImage.image = nil
        }
        if let cardNum = textField.text, cardNum.count >= 7{
            NSObject.cancelPreviousPerformRequests(withTarget: self,selector: #selector(getCardType),object: textField)
            self.perform(#selector(getCardType),with: textField,afterDelay: 1.0)
        }
        if let cardNum = textField.text, cardNum.count < 19{
            self.delegate?.cardNumber(cardNum: String.empty)
        }
        if let cardNum = textField.text, cardNum.count == 19{
            self.delegate?.checkEmi(cardNum: cardNum)
            self.delegate?.cardNumber(cardNum: cardNum)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.cardNameTxtFld, textField.text!.count >= 4 {
            self.delegate?.cardName(cardName: self.cardNameTxtFld.text!)
        }
        if textField == self.cardNameTxtFld, textField.text!.count < 4 {
            self.delegate?.cardName(cardName: String.empty)
        }
        if textField == self.cvvTxtFld, textField.text!.count == 3 {
            self.delegate?.cardCvv(cvv: self.cvvTxtFld.text!)
        }
        if textField == self.cvvTxtFld, textField.text!.count < 3 {
            self.delegate?.cardCvv(cvv: String.empty)
        }
    }
    
    @objc func getCardType(textField: UITextField) {
        if let enteredText = textField.text?.replacingOccurrences(of: " ", with: ""){
            DataClient.checkCardType(cardNumber: enteredText) { (status, data) in
                if status{
                    if let cardData = data{
                        let cardtype = cardData.components(separatedBy: "|")
                        self.cardTypeImage.setKfImage(with: cardtype[3])
                    }
                }else{
                    print("errorr in finding card type")
                }
            }
        }
    }
    
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()

        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""

        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if textField == self.cardNumTxtFld {
            return newLength <= 19
        }
        if textField == self.cardNameTxtFld {
            return newLength <= 50
        }
        if textField == self.cvvTxtFld{
            return newLength <= 3
        }
        return true
    }
}
