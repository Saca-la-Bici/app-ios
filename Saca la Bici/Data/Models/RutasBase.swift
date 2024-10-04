//
//  RutasBase.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 03/10/24.
//

import Foundation

struct RutasBase: Identifiable, Codable {
    let id: String
    let titulo: String
    let distancia: String
    let tiempo: String
    let nivel: String
    let lugar: String
    let descanso: String
    let coordenadas: [CoordenadasBase]
}
