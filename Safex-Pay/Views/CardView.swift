//
//  CardView.swift
//  SafexPay
//
//  Created by Sandeep on 8/17/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
import RSSelectionMenu
import KRProgressHUD

protocol DetailViewProtocol {
    func openWebURL(html: String, amount: String)
    func openWebForTabby(session: CheckoutSession, productType: ProductType)
    func backToMain()
}

class CardView: UIView {
    
    // MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var amountPayableLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    // MARK:- Properties
    var isSectionExpanded = false
    var delegate: DetailViewProtocol?
    var mechantId = String.empty
    var price = String.empty
    private var orgPrice = String.empty
    var orderId = String.empty
    var isEmiTabOpened = false
    var isEmiAvailable = false
    var eppData: [Epp]?
    var cardData: [PaymentModeDetailsList]?
    var custName = String.empty
    var custEmail = String.empty
    var custNumber = String.empty
    private var pgId = String.empty
    private var pgMode = String.empty
    private var schemeId = String.empty
    private var cardNumber = String.empty
    private var cardName = String.empty
    private var cvv = String.empty
    private var expMonth = String.empty
    private var expYear = String.empty
    private var instalmentMonths = String.empty
    var externalKey = String.empty
    var view = UIViewController()
    
    // MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK:- Helpers
    func setupCardView(info: paymentModeNew){
        self.cardData = info.modeDetailList
        self.pgMode = info.payModeID
        self.orgPrice = self.price
        self.priceLbl.text = "AED \(price)"
        self.setupTableView()
        print(price,orderId,custName,custNumber,custEmail)
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AddCardCell", bundle: safexBundle), forCellReuseIdentifier: "AddCardCell")
        self.tableView.register(UINib(nibName: "EmiCellTable", bundle: safexBundle), forCellReuseIdentifier: "EmiCellTable")
        
        self.tableView.register(UINib(nibName: "SavedCardsHeader", bundle: safexBundle), forHeaderFooterViewReuseIdentifier: "SavedCardsHeader")
        self.tableView.register(UINib(nibName: "EmiViewHeader", bundle: safexBundle), forHeaderFooterViewReuseIdentifier: "EmiViewHeader")
    }
    
    @IBAction func backToMainPressed(_ sender: UIButton) {
        self.delegate?.backToMain()
    }
    
    @IBAction func payNowPressed(_ sender: UIButton) {
        if let data = self.cardData?.first {
            self.pgId = data.pgDetailsResponse.pgID
            self.schemeId = data.schemeDetailsResponse.schemeID
            self.validate()
        }
    }
    
    private func validate(){
        if self.cardNumber.isBlank{
            view.showAlert(title: "", message: "Please enter valid card number")
            return
        }
        if self.cardName.isBlank{
            view.showAlert(title: "", message: "Please enter name on card")
            return
        }
        if self.expMonth.isBlank{
            view.showAlert(title: "", message: "Please enter expiry month")
            return
        }
        if self.expYear.isBlank{
            view.showAlert(title: "", message: "Please enter expiry year")
            return
        }
        if self.cvv.isBlank{
            view.showAlert(title: "", message: "Please enter valid cvv")
            return
        }
        self.startPayment()
    }
}

extension CardView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCardCell") as! AddCardCell
            cell.delegate = self
            cell.view = self.view
//            cell.checkAllFields()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmiCellTable") as! EmiCellTable
            if let data = self.eppData{
                cell.eppData = data
            }
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            if isEmiTabOpened{
                return 180
            }else{
                self.instalmentMonths = String.empty
                self.amountPayableLbl.text = "Amount payable"
                self.price = self.orgPrice
                self.priceLbl.text = "AED \(price)"
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            case 0:
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SavedCardsHeader") as! SavedCardsHeader
                view.tag = section
                view.sectionExpandButton.isHidden = true
                view.setdata(headerLbl: "Enter card details")
                return view
            case 1:
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EmiViewHeader") as! EmiViewHeader
                view.tag = section
                view.delegate = self
                view.setdata(headerLbl: "Choose instalment plan", isEmiAvailable: self.isEmiAvailable)
                return view
            default:
                return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30
        case 1:
            return 96
        default:
            return 0
        }
    }
}

extension CardView: AddCardCellProtocol {
    func cardNumber(cardNum: String) {
        self.cardNumber = cardNum.replacingOccurrences(of: " ", with: "")
    }
    
    func cardName(cardName: String) {
        self.cardName = cardName
    }
    
    func cardExpMonth(expMonth: String) {
        self.expMonth = expMonth
    }
    
    func cardExpYear(expYear: String) {
        self.expYear = expYear
    }
    
    func cardCvv(cvv: String) {
        self.cvv = cvv
    }

    func checkEmi(cardNum: String) {
        let cardNumber = cardNum.replacingOccurrences(of: " ", with: "")
        DataClient.checkEmiOnCard(cardNumber: cardNumber, merchantId: self.mechantId, amount: self.price) { (status, data) in
            if status{
                if let emiData = data, emiData.count > 0{
                    self.isEmiAvailable = true
                    self.bindEppData(data: emiData)
                }else{
                    self.isEmiAvailable = false
                    print("Emi options not available")
                }
            }else{
                print("error on emi")
            }
        }
    }
    
    func bindEppData(data: [String]){
        self.eppData = [Epp]()
        data.forEach { (eppData) in
            let strData = eppData.components(separatedBy: "|")
            let months = Float(strData[1])?.clean
            let epp = Epp(amount: strData[0], months: months, monthlyEmi: strData[2], interest: strData[3], totalAmount: strData[4], roi: strData[5], bankId: strData[6], processingFees: strData[7], percentageFees: strData[8])
            self.eppData?.append(epp)
        }
        self.tableView.reloadData()
    }
}

extension CardView: EmiCellTableProtocol, EmiViewHeaderProtocol {
    func sendEppInstalmentMonths(months: String, amount: String) {
        self.instalmentMonths = months
        self.price = amount
        self.amountPayableLbl.text = "Approx EMI per month"
        self.priceLbl.text = "AED \(self.price)"
    }
    
    func isEmiSwitchEnabled(state: Bool) {
        self.isEmiTabOpened = state
        if state{
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
        }else{
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        self.tableView.reloadData()
    }
    
    func reloadMainTable() {
        self.tableView.reloadData()
    }
}

extension CardView: SavedCardsHeaderProtocol {
    func sectionExpandPressed(tag: Int) {
        if isSectionExpanded {
            self.isSectionExpanded = false
            let sections = IndexSet(integer: tag)
            tableView.reloadSections(sections, with: .top)
        } else {
            self.isSectionExpanded = true
            let sections = IndexSet(integer: tag)
            tableView.reloadSections(sections, with: .top)
        }
    }
    
    
}

extension CardView{
    private func startPayment(){
        KRProgressHUD.show()
        
        DataClient.paymentCallback(merchantId: self.mechantId, merchantKey: self.externalKey, orderId: self.orderId, orderAmount: self.price, countryCode: countryCode, currency: "AED", txnType: "SALE", pgId: self.pgId, pgMode: self.pgMode, schemeId: self.schemeId, installmentMonths: self.instalmentMonths, cardNumber: self.cardNumber, expMonth: self.expMonth, expYear: self.expYear, cvv: self.cvv, cardName: self.cardName,customerName: self.custName, customerEmail: self.custEmail, customerMobile: self.custNumber, customerUniqueId: "", isCustomerLoggedIn: "Y", billAdress: "House 123, Sector 23", billCity: "Faridabad", billState: "Haryana", billCountry: "India", billZipCode: "121005") { (status, data) in
            if status{
                KRProgressHUD.dismiss()
                if let datahtml = data{
                    self.delegate?.openWebURL(html: datahtml, amount: self.price)
                }
            }else{
                KRProgressHUD.dismiss()
                Console.log(ErrorMessages.somethingWentWrong)
            }
        }
    }
}
