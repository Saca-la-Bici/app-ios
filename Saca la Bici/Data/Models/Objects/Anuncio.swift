//
//  Anuncio.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import SwiftUI

struct AnunciosResponse: Codable {
    let anuncio: [Anuncio]
    let rol: String
}

struct Anuncio: Identifiable, Codable {
    var id: String
    var titulo: String
    var contenido: String
    var imagen: String?
    var createdAt: String
    var fechaCaducidad: String
    
    var icon: String = "A"  // Valor por defecto por ahora (imagen del usuario)
    var backgroundColor: Color = Color(UIColor.systemGray6)
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case titulo
        case contenido
        case imagen
        case createdAt
        case fechaCaducidad
    }
}

struct ResponseMessage: Codable {
    let message: String
}
