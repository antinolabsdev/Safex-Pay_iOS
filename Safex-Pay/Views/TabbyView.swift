//
//  TabbyView.swift
//  Safex-Pay
//
//  Created by Sandeep on 30/10/20.
//

import UIKit
import KRProgressHUD
import Alamofire

class TabbyView: UIView {
    
    // MARK:- Outlets
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var payLaterView: UIView!{
        didSet{
            payLaterView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var payLaterRadioImg: UIImageView!
    @IBOutlet weak var payInstalmentView: UIView!{
        didSet{
            payInstalmentView.isUserInteractionEnabled = false
        }
    }
    @IBOutlet weak var payInstalmentRadioImg: UIImageView!
    
    // MARK:- Properties
    var delegate: DetailViewProtocol?
    var mechantId = String.empty
    var price = String.empty
    var orderId = String.empty
    var custName = String.empty
    var custEmail = String.empty
    var custNumber = String.empty
    var tabbyData: [PaymentModeDetailsList]?
    var session: CheckoutSession?
    var selectedProduct: ProductType?
    private var pgId = String.empty
    private var pgMode = String.empty
    private var schemeId = String.empty
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
    
    func setupTabbyView(info: paymentModeNew){
        self.priceLbl.text = "AED \(price)"
        self.pgMode = info.payModeID
        self.tabbyData = info.modeDetailList
        let payLaterGest = UITapGestureRecognizer(target: self, action: #selector(selectLaterMode(sender:)))
        self.payLaterView.addGestureRecognizer(payLaterGest)
        let payInstalGest = UITapGestureRecognizer(target: self, action: #selector(selectInstalMode(sender:)))
        self.payInstalmentView.addGestureRecognizer(payInstalGest)
        self.createCheckoutSession()
    }
    
    @objc func selectLaterMode(sender : UITapGestureRecognizer) {
        selectedProduct = .payLater
        self.payLaterRadioImg.image = UIImage(named: "Selected_Radio", in: safexBundle, compatibleWith: nil)
        self.payInstalmentRadioImg.image = UIImage(named: "Unselected_Radio", in: safexBundle, compatibleWith: nil)
    }
    
    @objc func selectInstalMode(sender : UITapGestureRecognizer) {
        selectedProduct = .installments
        self.payInstalmentRadioImg.image = UIImage(named: "Selected_Radio", in: safexBundle, compatibleWith: nil)
        self.payLaterRadioImg.image = UIImage(named: "Unselected_Radio", in: safexBundle, compatibleWith: nil)
    }
    
    @IBAction func payBtnPressed(_ sender: UIButton) {  
        if selectedProduct != nil {
            self.delegate?.openWebForTabby(session: self.session!, productType: self.selectedProduct!)
        }else{
            view.showAlert(title: "", message: "Please select a payment method")
        }
    }
}

extension TabbyView{
    func createCheckoutSession() {
        let params: [String : Any] = ["payment": [
            "amount": price,
            "buyer": [
              "email": "successful.payment@tabby.ai",
              "name": "John Doe",
              "phone": "0500000001"
            ],
            "currency": "AED",
              ],
            "lang": "en",
            "merchant_code": "sa_store"
        ]
        
        let url = "https://api.tabby.ai/api/v2/checkout"
        let headers : HTTPHeaders = ["Authorization" : "Bearer " + "pk_test_eb5ec24c-0497-4008-9254-420a1472ace5" ]
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.prettyPrinted, headers: headers).responseDecodable(of: CheckoutSession.self) { (response) in
            if let session = response.value {
                self.session = session
                for type in session.configuration.availableProducts.keys {
                    switch type {
                    case "installments":
                        self.payInstalmentView.isUserInteractionEnabled = true
                    case "pay_later":
                        self.payLaterView.isUserInteractionEnabled = true
                    default:
                        continue
                    }
                }
            }
        }
    }
}
