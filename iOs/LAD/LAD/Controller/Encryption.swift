//
//  Encryption.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 3/31/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import CryptoSwift

class Encryption{
    private var iv:String
    private var size: Int
    
    init() {
        self.size = 10
        self.iv = AES.randomIV(self.size-2).toHexString()
        //Debe ser siempre el mismo iv
    }
    
    //Generate 32byte AES key
    func createAESKey() -> String? {
        
        var keyData = Data(count: self.size)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, self.size, $0)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
    
    func encrypt(data: String) throws-> (String, String){
        let key = self.createAESKey()!
        
        let aes = try AES(key: key, iv: self.iv, padding: .pkcs7)
        
        let ciphertext = try aes.encrypt(Array(data.utf8))

        return (ciphertext.toHexString(), key)
    }
    
    func decrypt(data: String, key: String) throws-> String {
        if(!key.isEmpty){
            print("Voy")
            let aes = try AES(key: key, iv: self.iv, padding: .pkcs7)
            print(aes)
            let ciphertext = try aes.decrypt(Array(data.utf8))
            
            return ciphertext.toHexString()
        }else{
            return data
        }
    }
    
}
