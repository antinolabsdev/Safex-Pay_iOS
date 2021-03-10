//
//  AESManager.swift
//  SafexPay
//
//  Created by Sandeep on 09/09/20.
//  Copyright © 2020 Antino Labs. All rights reserved.
//

import Foundation
import CryptoSwift

final class AESClient{

    enum AESData{
    //    static let decryptKey = "oqUl4D0LqA4plZw4reAX/K3UKJoQdet0k/N6X6K4Y5k="
//        static let decryptKey = "UzYf5qDVnTLYsf1/2/JTmjy2qFHW4GU4mcOQ684MaCM="
    //    static let decryptKey = "LSSd+r8CE82t9DA21Br+i7euZKXKabHm1UKFzd6boTc="
        static let internalKey = "HiktfH0Mhdla4zDg0/4ASwFQh2OS+nf9MVL0ik3DsmE="
    }
    
    class func AESEncrypt(dataToEncrypt: String, encryptionKey: String) -> String{
        let base64DecodedData = NSData(base64Encoded: encryptionKey, options: .ignoreUnknownCharacters)
        let input: Array<UInt8> = Array(dataToEncrypt.utf8)
        let key: Array<UInt8> = [UInt8](base64DecodedData! as Data)
        let iv: Array<UInt8> = Array("0123456789abcdef".utf8)
        do
        {
            let encrypted = try AES(key: key, blockMode: CBC(iv: iv), padding: .pkcs7).encrypt(input)
            let encData = Data(bytes: encrypted, count: Int(encrypted.count))
            let base64String: String = encData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
            let result = String(base64String)
            return result
        }
        catch
        {
            return ""
        }
    }

    class func AESDecrypt(dataToDecrypt: String, decryptionKey: String) -> String{
        let base64DecodedData = NSData(base64Encoded: decryptionKey, options: .ignoreUnknownCharacters)
        let bytes1=[UInt8](base64DecodedData! as Data)
        let encryptedData = NSData(base64Encoded: dataToDecrypt, options:[])!
        let count = encryptedData.length / MemoryLayout<UInt8>.size
        var encrypted = [UInt8](repeating: 0, count: count)
        let iv: Array<UInt8> = Array("0123456789abcdef".utf8)
        encryptedData.getBytes(&encrypted, length:count * MemoryLayout<UInt8>.size)
        do
        {
            let decrypted = try AES(key: bytes1, blockMode: CBC(iv: iv), padding: .pkcs7).decrypt(encrypted)
            let decryptedString = String(bytes: decrypted, encoding: String.Encoding.utf8)!
            return decryptedString
        }
        catch
        {
            return ""
        }
    }
}
