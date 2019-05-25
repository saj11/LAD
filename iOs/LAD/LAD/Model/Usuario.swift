//
//  Usuario.swift
//  LAD
//
//  Created by Joseph Salazar Acuña on 4/22/19.
//  Copyright © 2019 Joseph Salazar Acuña. All rights reserved.
//

import Foundation

enum TipoUsuario {
    case Estudiante
    case Profesor
}

protocol Usuario {
    var nombre: String { get }
    var apellidos: String { get }
    var correo: String { get }
    var tipo: TipoUsuario { get set }
}
