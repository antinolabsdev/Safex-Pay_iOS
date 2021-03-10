//
//  TransactionVC.swift
//  SafexPay
//
//  Created by Sandeep on 8/18/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit

class TransactionVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var navBarTopView: UIView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var tryAgainBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var logoImg: UIImageView!
    
    // MARK:- Properties
    var isSucess = true
    var BrandDetails: BrandingDetail?
    var price = String.empty
    var orderId = String.empty
    
    // MARK:- Lifecycle
    public init() {
        super.init(nibName: "TransactionVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        if let details = self.BrandDetails{
            self.logoImg.setKfImage(with: details.logo)
        }
//        self.navBarBottomView.backgroundColor = headerColor
//        self.navBarTopView.backgroundColor = headerColor
        self.navBarBottomView.addShadow(color: UIColor.lightGray, offSet: CGSize(width: 0, height: 3))
//        self.tryAgainBtn.backgroundColor = headerColor
        self.tryAgainBtn.layer.cornerRadius = 2
        self.tryAgainBtn.layer.masksToBounds = true
        if self.isSucess{
            self.setupSuccessView()
        }else{
            self.setupFailureView()
        }
    }
    
    func setupFailureView(){
        let failedView = UINib(nibName: "TransactionView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! TransactionView
        failedView.frame = self.contentView.bounds
        failedView.paymentFailed(amount: self.price, orderNo: self.orderId)
        self.tryAgainBtn.setTitle("Try again", for: .normal)
        self.isSucess = false
        self.contentView.addSubview(failedView)
    }
    
    func setupSuccessView(){
        let successView = UINib(nibName: "TransactionView", bundle: safexBundle).instantiate(withOwner: nil, options: nil).first as! TransactionView
        successView.frame = self.contentView.bounds
        successView.paymentSuccess(amount: self.price, orderNo: self.orderId)
        self.tryAgainBtn.setTitle("Done", for: .normal)
        self.isSucess = true
        self.contentView.addSubview(successView)
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func tryAgainPressed(_ sender: UIButton) {
        if isSucess{
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        }else{
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
