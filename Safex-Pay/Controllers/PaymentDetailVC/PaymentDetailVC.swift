//
//  PaymentDetailVC.swift
//  SafexPay
//
//  Created by Sandeep on 16/10/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class PaymentDetailVC: UIViewController {
    // MARK:- Outlets
    @IBOutlet weak var navBarTopView: UIView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    
    // MARK:- Properties
    var BrandDetails: BrandingDetail?
    var mechantId = String.empty
    var price = String.empty
    var orderId = String.empty
    var custName = String.empty
    var custEmail = String.empty
    var custNumber = String.empty
    var viewType: paymentModeNew?
    var externalKey = String.empty
    
    // MARK:- Lifecycle
    public init() {
        super.init(nibName: "PaymentDetailVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        if let modetype = self.viewType{
            self.setChosenView(of: modetype, on: self)
            self.paymentMethodLbl.text = " \(modetype.paymentName)  "
        }
    }

    func setupView(){
        if let details = self.BrandDetails{
            self.logoImg.setKfImage(with: details.logo)
        }
        self.navBarBottomView.addShadow(color: UIColor.lightGray, offSet: CGSize(width: 0, height: 3))
        self.orderLbl.text = "Order no." + "" + "\(orderId)"
    }
    
    func setupWebView(html: String,amount: String){
        let vc = WebVC()
        vc.modalPresentationStyle = .fullScreen
        vc.htmlStr = html
        vc.price = amount
        vc.orderId = self.orderId
        vc.externalKey = self.externalKey
        vc.BrandDetails = self.BrandDetails
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PaymentDetailVC {
    func setChosenView(of type: paymentModeNew, on: UIViewController){
        switch type.payModeID {
        case "CC":
            setupCardView(on: on, info: type)
        case "DC":
            setupCardView(on: on, info: type)
        case "TB":
            setupTabbyView(on: on, info: type)
        case "CE":
            setupCardView(on: on, info: type)
        default:
            break
        }
    }
    
    func setupCardView(on VC: UIViewController, info: paymentModeNew){
        let cardView = UINib(nibName: "CardView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! CardView
        cardView.frame = self.contentView.bounds
        cardView.mechantId = self.mechantId
        cardView.price = self.price
        cardView.orderId = self.orderId
        cardView.custName = self.custName
        cardView.custEmail = self.custEmail
        cardView.custNumber = self.custNumber
        cardView.externalKey = self.externalKey
        cardView.setupCardView(info: info)
        cardView.view = VC
        cardView.delegate = self
        self.contentView.addSubview(cardView)
    }
    
    func setupTabbyView(on VC: UIViewController, info: paymentModeNew){
        let tabby = UINib(nibName: "TabbyView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! TabbyView
        tabby.frame = self.contentView.bounds
        tabby.mechantId = self.mechantId
        tabby.externalKey = self.externalKey
        tabby.orderId = self.orderId
        tabby.price = self.price
        tabby.custName = self.custName
        tabby.custEmail = self.custEmail
        tabby.custNumber = self.custNumber
        tabby.view = VC
        tabby.delegate = self
        tabby.setupTabbyView(info: info)
        self.contentView.addSubview(tabby)
    }
    
    func setupTabbyWebView(session: CheckoutSession, productType: ProductType){
        let vc = TabbyWebVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.session = session
        vc.productType = productType
        vc.price = price
        vc.orderId = self.orderId
        vc.BrandDetails = self.BrandDetails
//        let nav = UINavigationController(rootViewController: vc)
        present(vc, animated: true, completion: nil)
        
    }
}

extension PaymentDetailVC: DetailViewProtocol {
    func openWebForTabby(session: CheckoutSession, productType: ProductType) {
        self.setupTabbyWebView(session: session, productType: productType)
    }
    
    func openWebURL(html: String, amount: String) {
        self.setupWebView(html: html, amount: amount)
    }
    
    func backToMain() {
        self.dismiss(animated: false, completion: nil)
    }
}
