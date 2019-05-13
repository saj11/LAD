//
//  codigo.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 3/24/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import UIKit

class Codigo{
    private var data:String
    private var qrCode: String
    
    init() {
        self.data = ""
        self.qrCode = ""
    }
    
    init(code: String) {
        self.qrCode = code
        
        self.data = ""
    }
    
    func getUIImage()-> UIImage{
        let dataDecoded = Data(base64Encoded: self.qrCode, options: .ignoreUnknownCharacters)!//NSData(base64Encoded: self.qrCode)! as Data
        
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        return decodedimage
    }
    
    func getCIImage()-> CIImage{
        return CIImage(cgImage: getUIImage().cgImage!)
    }
    
    func setData(data:String) {
        self.data = data
        self.createImage()  //Setea el codigo qr en string
    }
    
    func getData()-> String { return self.data }
    
    func getQRCode()-> String { return self.qrCode }
    
    private func createCode() -> CIImage?{
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(self.data.data(using: .utf8), forKey: "inputMessage")
        qrFilter.setValue("Q", forKey: "inputCorrectionLevel")
        guard let qrImage = qrFilter.outputImage else { return nil }
        
        return qrImage
    }
    
    func createImage(){
        let qrImage = UIImage(ciImage: createCode()!)
        
        let imageData = qrImage.generatePNGRepresentation()
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)

        self.qrCode = strBase64
    }
    
}
