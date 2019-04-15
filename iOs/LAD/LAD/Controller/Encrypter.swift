//
//  Encrypter.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/13/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation

protocol Encrypter {
    static func encrypt(message: String) -> String
    func decrypt(message: String) -> String
}
