//
//  DataClient.swift
//  SafexPay
//
//  Created by Sandeep on 11/09/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import Foundation

final class DataClient {
    
    private enum EndPoint {
        static let branding_url = "\(BASE_URL)/api/query/merchantBrandingDetails"
        static let paymode_scheme = "\(BASE_URL)/api/query/payModeAndSchemeAPI"
        static let payment_callback = "\(BASE_URL)/appPay"
        static let saved_cards = "\(BASE_URL)/api/query/getCardsByMerchant"
        static let card_check = "\(BASE_URL)/api/query/checkCardTpe/"
        static let emi_check = "\(BASE_URL)/checkEmiOnCard/"
    }
    
    class func getBrandingDetails(merchantId: String,completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        let encMerchantId = AESClient.AESEncrypt(dataToEncrypt: merchantId, encryptionKey: AESClient.AESData.internalKey)
        let param = ["me_id":encMerchantId]
        DataService.instance.postRequest(url: EndPoint.branding_url, postParam: param, header: nil) { (status, data) in
            if status{
                if let errorDetails = data?.value(forKey: "error_details") as? NSDictionary {
                    if errorDetails.value(forKey: "error_code") as? String == "1" {
                        if let details = data?.value(forKey: "merchantBrandingDetails") as? String{
                            completion(true,details)
                        }
                    }else {
                        completion(false,nil)
                    }
                }
            }else{
                completion(false,nil)
            }
        }
    }
    
    class func checkCardType(cardNumber: String,completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        DataService.instance.postRequestString(url: EndPoint.card_check + "\(cardNumber)", postParam: nil, header: nil) { (status, data) in
            if status{
                if let details = data as? String{
                    completion(true,details)
                }
            }else{
                completion(false,nil)
            }
        }
    }
    
    class func checkEmiOnCard(cardNumber: String, merchantId: String, amount: String,completion: @escaping (_ sataus:Bool,_ data:[String]?)->()){
        let url = EndPoint.emi_check + "\(cardNumber)" + "/\(merchantId)" + "/\(amount)"
        DataService.instance.postRequestArray(url: url, postParam: nil, header: nil) { (status, data) in
            if status{
                if let details = data as? [String]{
                    completion(true,details)
                }
            }else{
                completion(false,nil)
            }
        }
    }
    
    class func getPaymodes(merchantId: String,completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        let encMerchantId = AESClient.AESEncrypt(dataToEncrypt: merchantId, encryptionKey: AESClient.AESData.internalKey)
        let param = ["me_id":encMerchantId]
        DataService.instance.postRequest(url: EndPoint.paymode_scheme, postParam: param, header: nil) { (status, data) in
            if status{
                if let errorDetails = data?.value(forKey: "error_details") as? NSDictionary {
                    if errorDetails.value(forKey: "error_code") as? String == "1" {
                        if let details = data?.value(forKey: "schemes") as? String{
                            completion(true,details)
                        }
                    }else {
                        completion(false,nil)
                    }
                }
            }else{
                completion(false,nil)
            }
        }
    }
    
    class func getSavedCards(merchantId: String,completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        let encMerchantId = AESClient.AESEncrypt(dataToEncrypt: merchantId, encryptionKey: AESClient.AESData.internalKey)
        let param = ["me_id": encMerchantId]
        DataService.instance.postRequest(url: EndPoint.saved_cards, postParam: param, header: nil) { (status, data) in
            if status{
                if let errorDetails = data?.value(forKey: "error_Details") as? NSDictionary {
                    if errorDetails.value(forKey: "error_code") as? String == "1" {
                        if let details = data?.value(forKey: "cardsDetails") as? String{
                            completion(true,details)
                        }
                    }else {
                        completion(false,nil)
                    }
                }
            }else{
                completion(false,nil)
            }
        }
    }
    
    class func paymentCallback(merchantId: String, merchantKey: String, orderId: String, orderAmount: String, countryCode: String, currency: String, txnType: String, pgId: String, pgMode: String, schemeId: String, installmentMonths: String, cardNumber: String, expMonth: String, expYear: String, cvv: String, cardName: String, customerName: String, customerEmail: String , customerMobile: String, customerUniqueId: String, isCustomerLoggedIn: String, billAdress: String, billCity: String, billState: String, billCountry: String, billZipCode: String, completion: @escaping (_ sataus:Bool,_ data:String?)->()){
        let txn_details = "fab|\(merchantId)|\(orderId)|\(orderAmount)|\(countryCode)|\(currency)|\(txnType)|http://localhost/safexpay/response.php|http://localhost/safexpay/response.php|MOBILE"
        print(txn_details)
        let pg_details = "\(pgId)|\(pgMode)|\(schemeId)|\(installmentMonths)"
        print(pg_details)
        let card_details = "\(cardNumber)|\(expMonth)|\(expYear)|\(cvv)|\(cardName)"
        print(card_details)
        let cust_details = "\(customerName)|\(customerEmail)|\(customerMobile)|\(customerUniqueId)|\(isCustomerLoggedIn)"
        print(cust_details)
        let bill_details = "\(billAdress)|\(billCity)|\(billState)|\(billCountry)|\(billZipCode)"
        print(bill_details)
        let ship_details = "||||||"
        print(ship_details)
        let item_details = "||"
        print(item_details)
        let other_details = "||||"
        print(other_details)
        
        let param: [String:Any] = [
            "txn_details":AESClient.AESEncrypt(dataToEncrypt: txn_details, encryptionKey: merchantKey),
            "pg_details":AESClient.AESEncrypt(dataToEncrypt: pg_details, encryptionKey: merchantKey),
            "card_details":AESClient.AESEncrypt(dataToEncrypt: card_details, encryptionKey: merchantKey),
            "cust_details":AESClient.AESEncrypt(dataToEncrypt: cust_details, encryptionKey: merchantKey),
            "bill_details":AESClient.AESEncrypt(dataToEncrypt: bill_details, encryptionKey: merchantKey),
            "ship_details":AESClient.AESEncrypt(dataToEncrypt: ship_details, encryptionKey: merchantKey),
            "item_details":AESClient.AESEncrypt(dataToEncrypt: item_details, encryptionKey: merchantKey),
            "other_details":AESClient.AESEncrypt(dataToEncrypt: other_details, encryptionKey: merchantKey),
            "me_id": "\(merchantId)"
        ]
        
        DataService.instance.postRequestString(url: EndPoint.payment_callback, postParam: param, header: nil) { (status, data) in
            if status{
                if let datahtml = data as? String{
                    completion(true,datahtml)
                }
            }else{
                print("Errrorrr")
                completion(false,nil)
            }
        }
    }
    
}
