//
//  CoordenadasBase.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 03/10/24.
//

import Foundation

struct CoordenadasBase: Codable, Identifiable {
    var id: String
    var latitud: Double
    var longitud: Double
    var tipo: String
}

