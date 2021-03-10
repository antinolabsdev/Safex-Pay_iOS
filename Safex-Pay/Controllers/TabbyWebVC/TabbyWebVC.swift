//
//  TabbyWebVC.swift
//  Safex-Pay
//
//  Created by Sandeep on 20/11/20.
//

import UIKit
import WebKit

class TabbyWebVC: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {

    // MARK:- Outlets
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var navBarBottomView: UIView!
    @IBOutlet weak var webViewContainer: UIView!
    
    // MARK:- Properties
    var session: CheckoutSession?
    var productType: ProductType?
    var BrandDetails: BrandingDetail?
    var price = String.empty
    var orderId = String.empty
    
    var webView: WKWebView!
    
    // MARK:- Lifecycle
    
    public init() {
        super.init(nibName: "TabbyWebVC", bundle: safexBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webConfiguration.preferences.javaScriptEnabled = true
//        let js = """
//            var launchTabby = true;
//            window.SDK = {
//                config: {
//                    direction: 'ltr',
//                    onChange: function(data) {
//                        window.webkit.messageHandlers.tabbyAppListener.postMessage(JSON.stringify(data));
//                        if (data.status === 'created' && launchTabby) {
//                            Tabby.launch({product: '\(productType!.rawValue)'});
//                            launchTabby = false;
//                        }
//                    },
//                    onClose: function() {
//                        window.webkit.messageHandlers.tabbyAppListener.postMessage('close');
//                    }
//                }
//            };
//        """
//        webConfiguration.userContentController.addUserScript(WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false))
//        webConfiguration.userContentController.add(self, name: "tabbyAppListener")
//
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
//        view = webView
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.loadWebView()
    }
    
    func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        let js = """
            var launchTabby = true;
            window.SDK = {
                config: {
                    direction: 'ltr',
                    onChange: function(data) {
                        window.webkit.messageHandlers.tabbyAppListener.postMessage(JSON.stringify(data));
                        if (data.status === 'created' && launchTabby) {
                            Tabby.launch({product: '\(productType!.rawValue)'});
                            launchTabby = false;
                        }
                    },
                    onClose: function() {
                        window.webkit.messageHandlers.tabbyAppListener.postMessage('close');
                    }
                }
            };
        """
        webConfiguration.userContentController.addUserScript(WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false))
        webConfiguration.userContentController.add(self, name: "tabbyAppListener")

//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.webViewContainer.frame.width, height: self.webViewContainer.frame.height), configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
//        view = webView
        self.webViewContainer.addSubview(webView)
        self.loadWebView()
    }
    
    private func loadWebView(){
        let urlString = "https://checkout.tabby.ai/"
        if var urlComponents = URLComponents(string: urlString) {
            let queryItems: [URLQueryItem] = [
                URLQueryItem(name: "apiKey", value: "pk_test_eb5ec24c-0497-4008-9254-420a1472ace5"),
                URLQueryItem(name: "sessionId", value: session?.id),
                URLQueryItem(name: "product", value: productType?.rawValue),
            ]
            urlComponents.queryItems = queryItems
            let request = URLRequest(url: urlComponents.url!)
            webView.load(request)
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    private func setupTransactionScreen(isSuccess: Bool){
        let vc = TransactionVC()
        vc.modalPresentationStyle = .fullScreen
        vc.isSucess = isSuccess
        vc.price = self.price
        vc.orderId = self.orderId
        vc.BrandDetails = self.BrandDetails
        present(vc, animated: true, completion: nil)
    }

}

extension TabbyWebVC{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        print(#function)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage){
        if let msg = message.body as? String {
            if msg == "close" {
                
            } else {
                let session: CreatedCheckoutSession = try! JSONDecoder().decode(CreatedCheckoutSession.self, from: Data(msg.utf8))
                switch session.payment?.status {
                case .authorized:
                    self.setupTransactionScreen(isSuccess: true)
                case .rejected:
                    self.setupTransactionScreen(isSuccess: false)
                default:
                    break
                }
            }
        }
    }
}
