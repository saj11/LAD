//
//  Compression.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/6/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation
import Compression

class Compressioner {
    static private let algorithm = COMPRESSION_LZFSE
    
    static func compress(data:String)-> NSData{
        
        var sourceBuffer = Array(data.utf8)
        let destinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        
        let compressedSize = compression_encode_buffer(destinationBuffer, data.count,
                                                       &sourceBuffer, data.count,
                                                       nil, self.algorithm)
        
        let encodedData = NSData(bytesNoCopy: destinationBuffer,
                                 length: compressedSize)
        
        return encodedData
    }
    
}
