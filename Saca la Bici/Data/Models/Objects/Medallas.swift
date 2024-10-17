//
//  Medallas.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 15/10/24.
//

import Foundation

struct MedallasResponse: Codable {
    let medallasActivas: [Medalla]
}

struct Medalla: Identifiable, Codable {
    let id = UUID()
    let _id: String
    let nombre: String
    let imagen: String
    let estado: Bool
    let idMedalla: Int
    
    enum CodingKeys: String, CodingKey {
        case _id, nombre, imagen, estado, idMedalla
    }
}
