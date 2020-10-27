//
//  Safex-pay.swift
//  Safex-Pay
//
//  Created by Sandeep on 27/10/20.
//

import UIKit

@objc open class Safex_pay: NSObject {
    
    public static let sharedInstance = Safex_pay()
    
    override init() {
        super.init()
    }
    
    @objc open func configure(MerchantId: String){
        print("Hello")
    }
}
