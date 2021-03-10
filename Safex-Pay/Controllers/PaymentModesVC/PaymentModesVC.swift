//
//  PaymentModesVCViewController.swift
//  SafexPay
//
//  Created by Sandeep on 8/13/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
import KRProgressHUD

class PaymentModesVC: UIViewController {
    // MARK:- Outlets
    @IBOutlet weak var navBarTopView: UIView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Properties
    var BrandDetails: BrandingDetail?
    var mechantId = String.empty
    var price = String.empty
    var orderId = String.empty
    var custName = String.empty
    var custEmail = String.empty
    var custNumber = String.empty
    var externalKey = String.empty
//    private var paymodes: [PaymentMode]?
    private var paymentmodes: [paymentModeNew]?
    
    // MARK:- Lifecycle
    public init() {
        super.init(nibName: "PaymentModesVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPaymodes(merchantId: self.mechantId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.getSavedCards(merchantId: self.mechantId)
        setupView()
        setuptableView()
    }
    
    // MARK:- Helpers
    
    func setupView(){
        if let details = self.BrandDetails{
            self.logoImg.setKfImage(with: details.logo)
        }
//        self.navBarBottomView.backgroundColor = headerColor
//        self.navBarTopView.backgroundColor = headerColor
        self.navBarBottomView.addShadow(color: UIColor.lightGray, offSet: CGSize(width: 0, height: 3))
        self.amountLbl.text = "AED \(price)"
        self.orderLbl.text = "Order no:" + "" + "\(orderId)"
    }
    
    func setuptableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PaymentModeCell", bundle: safexBundle), forCellReuseIdentifier: "PaymentModeCell")
    }
    
    func removeSubview(tag: Int){
        guard let viewWithTag = self.view.viewWithTag(tag) else {return}
        viewWithTag.removeFromSuperview()
    }
    
    func setupDetailView(for type: paymentModeNew){
        let vc = PaymentDetailVC()
        vc.modalPresentationStyle = .fullScreen
        vc.price = self.price
        vc.orderId = self.orderId
        vc.viewType = type
        vc.mechantId = self.mechantId
        vc.custName = self.custName
        vc.custEmail = self.custEmail
        vc.custNumber = self.custNumber
        vc.externalKey = self.externalKey
        vc.BrandDetails = self.BrandDetails
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func closePaymentGateway(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PaymentModesVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentmodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentModeCell") as! PaymentModeCell
        if let mode = self.paymentmodes?[indexPath.row]{
            cell.setData(mode: mode)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let mode = self.paymentmodes?[indexPath.row]{
            print(mode.paymentName)
            self.setupDetailView(for: mode)
        }
    }
}

extension PaymentModesVC{
    private func getPaymodes(merchantId: String){
        KRProgressHUD.show()
        DataClient.getPaymodes(merchantId: merchantId) { (status, data) in
            if status{
                if let details = data{
                    self.decryptBrandingDetail(encData: details)
                }
            }else{
                KRProgressHUD.dismiss()
                Console.log(ErrorMessages.somethingWentWrong)
            }
        }
    }
    
    private func decryptBrandingDetail(encData: String){
        let payloadResponse = AESClient.AESDecrypt(dataToDecrypt: encData, decryptionKey: self.externalKey)
        let dataDict = convertToArrayDictionary(text: payloadResponse)
//        print(dataDict)
        KRProgressHUD.dismiss()
        do{
            let data2 = try JSONSerialization.data(withJSONObject: dataDict as Any , options: .prettyPrinted)
            let decoder = JSONDecoder()
            do {
                var paymodes = [PaymentMode]()
                paymodes = try decoder.decode([PaymentMode].self, from: data2)
                sortPaymentMethods(data: paymodes)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                KRProgressHUD.dismiss()
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                KRProgressHUD.dismiss()
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                KRProgressHUD.dismiss()
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                KRProgressHUD.dismiss()
            } catch {
                print("error: ", error)
                KRProgressHUD.dismiss()
            }
        } catch {
            Console.log(error.localizedDescription)
            KRProgressHUD.dismiss()
        }
    }
    
    func sortPaymentMethods(data: [PaymentMode]){
        var paymodesSet = [paymentModeNew]()
        
        data.forEach({ (mode) in
            switch mode.payModeID {
            case "CC","DC" :
                paymodesSet.append(paymentModeNew(paymentName: "Pay by card", payModeID: "DC", modeDetailList: mode.paymentModeDetailsList))
            case "CE" :
                paymodesSet.append(paymentModeNew(paymentName: "Pay by instalments (credit card)", payModeID: mode.payModeID, modeDetailList: mode.paymentModeDetailsList))
            case "TB" :
                paymodesSet.append(paymentModeNew(paymentName: "Buy now pay later", payModeID: mode.payModeID, modeDetailList: mode.paymentModeDetailsList))
            default:
                return
            }
        })
        
        paymentmodes = paymodesSet.removingDuplicates()
        KRProgressHUD.dismiss()
        self.tableView.reloadData()
    }
}
