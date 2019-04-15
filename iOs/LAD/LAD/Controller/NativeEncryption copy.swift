//
//  NativeEncryption.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/13/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import LocalAuthentication

class NativeEncryption : Encrypter {
    private var accessControl: SecAccessControl?
    private let privateLabel: String
    private let publicLabel: String
    
    init() {
        self.publicLabel = "com.kharypnoz.LAD-PuK"
        self.privateLabel = "com.kharypnoz.LAD-PrK"
        self.generateKeys()
    }
    
    private func createAccessControl()-> SecAccessControl?{
        guard let accessControl =
            SecAccessControlCreateWithFlags(
                kCFAllocatorDefault,
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                [.privateKeyUsage, .biometryCurrentSet],
                nil)
            else {
                fatalError("cannot set access control")
                return nil
        }
        print("Init - AccessControl: \(accessControl)")
        return accessControl
    }
    
    private func generateKeys(){
        self.accessControl = self.createAccessControl()
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecAttrIsPermanent as String: true,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: self.privateLabel,
                kSecAttrAccessControl as String: self.accessControl as Any
            ]
        ]
        
        // create the key pair
        var _publicKey, _privateKey: SecKey?
        let status = SecKeyGeneratePair(attributes as CFDictionary, &_publicKey, &_privateKey)
        print("Status \(status)")
        guard status == errSecSuccess,
            let publicKey = _publicKey,
            let privateKey = _privateKey else {
                // couldn't generate key pair
                return
        }
        
        print("Gen - Public Key: \(publicKey)")
        print("Gen - Private Key: \(privateKey)")
        
        // force store the public key in the keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrApplicationTag as String: self.publicLabel,
            kSecValueRef as String: publicKey,
            kSecAttrIsPermanent as String: true,
            kSecReturnData as String: true,
        ]
        
        // add the public key to the keychain
        var raw: CFTypeRef?
        var statusKC = SecItemAdd(query as CFDictionary, &raw)
        print("Raw: \(raw)")
        print("Status: \(statusKC)")
    
        
        if statusKC == errSecSuccess {
            print("Funco")
        } else {
            print("Error")
            
        }

    }
    
    private func getPrivateKey() -> SecKey? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: self.privateLabel,
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true,
            kSecReturnPersistentRef as String: true,
        ]
        
        var privateKey: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &privateKey)
        
        guard status == errSecSuccess else {
            print("Gen Priv Key - Error: \(status)")
            return nil
        }
        
        return (privateKey as! SecKey)
    }
    
    func getPublicKey()-> SecKey? {
        /*guard let eCCPrivKey = getPrivateKey() else {
            print("ECC Pub Priv KeyGet Error")
            return nil
        }
        print("Public Key: \(eCCPrivKey)")
        guard let eCCPubKey = SecKeyCopyPublicKey(eCCPrivKey as SecKey) else {
            print("ECC Pub KeyGet Error")
            return nil
        }
        
        print("Public Key: \(eCCPubKey)")
        return eCCPubKey*/
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrApplicationTag as String: self.publicLabel,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            //kSecReturnData as String: true,
            kSecReturnRef as String: true,
            kSecReturnPersistentRef as String: true,
        ]
        
        var publicKey: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &publicKey)
        
        guard status == errSecSuccess else {
            print("Gen Priv Key - Error: \(status)")
            return nil
        }
        
        return (publicKey as! SecKey)
    }
    
    func encrypt(message: String) -> String {
        print("###################################################")
        
        let publicKey = self.getPublicKey()
        
        let messageData = message.data(using: String.Encoding.utf8)! as CFData
        
        print(SecKeyIsAlgorithmSupported(publicKey!, .encrypt, .eciesEncryptionStandardX963SHA256AESGCM))
        //let result = SecKeyCreateEncryptedData(publicKey!, .eciesEncryptionStandardX963SHA256AESGCM, messageData, &error)!
        
        return ""//result.base64EncodedString(options: [])
    }
    
    func decrypt(message: String) -> String {
        var error : Unmanaged<CFError>?
        
        let privateKey = self.getPrivateKey()
        let messageData = Data(base64Encoded: message, options: [])
        
        let result = SecKeyCreateDecryptedData(privateKey!, .eciesEncryptionStandardX963SHA256AESGCM, messageData! as CFData, &error)! as Data

        
        return String(data: result, encoding: String.Encoding.utf8)!
    }
    
    
}
