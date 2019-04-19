//
//  NativeEncryption.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/13/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import LocalAuthentication
import EllipticCurveKeyPair

class NativeEncryption : Encrypter {
    var context: LAContext!
    
    init() {
        self.context = LAContext()
    }
    
    struct Shared {
        static let manager: EllipticCurveKeyPair.Manager = {
            let publicAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAlwaysThisDeviceOnly, flags: [])
            let privateAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, flags: [.userPresence, .privateKeyUsage])
            
            let config = EllipticCurveKeyPair.Config(
                publicLabel: "payment.sign.public",
                privateLabel: "payment.sign.private",
                operationPrompt: "Generate de Encrypted Information",
                publicKeyAccessControl: publicAccessControl,
                privateKeyAccessControl: privateAccessControl,
                fallbackToKeychainIfSecureEnclaveIsNotAvailable: true
                )
            
            return EllipticCurveKeyPair.Manager(config: config)
        }()
    }
    
    static func encrypt(message: String) -> String {
        do {
            let messageData = message.data(using: .utf8)
            
            guard #available(iOS 10.3, *) else {
                print("Can not encrypt on this device (must be iOS 10.3)")
                return ""
            }
            
            let result = try Shared.manager.encrypt(messageData!)
            
            return result.base64EncodedString()
        }catch{
            print(error)
            return ""
        }
    }
    
    func decrypt(message: String)-> String {
        guard let encrypted = Data(base64Encoded: message) else {
            print("Missing text in unencrypted text field")
            return ""
        }

        guard #available(iOS 10.3, *) else {
            print("Can not encrypt on this device (must be iOS 10.3)")
            return ""
        }
        
        do{
            let result = try Shared.manager.decrypt(encrypted, authenticationContext: self.context)
            guard let decrypted = String(data: result, encoding: .utf8) else {
                print("Could not convert decrypted data to string")
                return ""
            }
            return decrypted
        }catch{
            print(error)
        }
        return ""
    }
    
    func signing(message: String){
        do{
            let digest = message.data(using: .utf8)!
            let signature = try Shared.manager.sign(digest, authenticationContext: self.context)
            print(signature)
        }catch{
            print(error)
        }
    }
}
