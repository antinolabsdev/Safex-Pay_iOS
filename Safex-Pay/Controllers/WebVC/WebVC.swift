//
//  WebVC.swift
//  SafexPay
//
//  Created by Sandeep on 15/10/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    // MARK:- Outlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navBarTopView: UIView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var orderLbl: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    
    // MARK:- Properties
    var htmlStr = String.empty
    var BrandDetails: BrandingDetail?
    var price = String.empty
    var orderId = String.empty
    var externalKey = String.empty
    
    //Tabby
    var session: CheckoutSession?
    var productType: ProductType?
    
    // MARK:- Lifecycle
    public init() {
        super.init(nibName: "WebVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
        self.loadWebView()
    }
    
    private func setupView(){
        if let details = self.BrandDetails{
            self.logoImg.setKfImage(with: details.logo)
        }
//        self.navBarBottomView.backgroundColor = headerColor
//        self.navBarTopView.backgroundColor = headerColor
        self.navBarBottomView.addShadow(color: UIColor.lightGray, offSet: CGSize(width: 0, height: 3))
        self.amountLbl.text =  "AED \(price)"
        self.orderLbl.text = "Order no." + "" + "\(orderId)"
    }
    
    private func loadWebView(){
        self.webView.loadHTMLString(htmlStr, baseURL: nil)
    }
    
    private func getCallBackData(url: String){
        let paramData = getQueryStringParameter(url: url, param: "txn_response")
        if let data = paramData {
            let paramDec = AESClient.AESDecrypt(dataToDecrypt: data, decryptionKey: self.externalKey)
            let words = paramDec.components(separatedBy: "|")
            print(words)
            if words.contains("Successful"){
                print("Success")
                self.setupTransactionScreen(isSuccess: true)
            }else{
                print("Failure")
                self.setupTransactionScreen(isSuccess: false)
            }
        }
    }
    
    private func setupTransactionScreen(isSuccess: Bool){
        let vc = TransactionVC()
        vc.modalPresentationStyle = .fullScreen
        vc.isSucess = isSuccess
        vc.price = self.price
        vc.orderId = self.orderId
        vc.BrandDetails = self.BrandDetails
        present(vc, animated: false, completion: nil)
    }
    
    private func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension WebVC {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString, urlStr.contains("localhost") {
//            print("callBack: \(urlStr)")
            self.getCallBackData(url: urlStr)
        }
        decisionHandler(.allow)
    }
    
}
