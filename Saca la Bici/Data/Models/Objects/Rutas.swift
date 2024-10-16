//
//  Rutas.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 15/10/24.
//

import Foundation

struct RutasResponse: Codable {
    let rutas: [Ruta]
    var permisos: [String]?
}

struct Ruta: Codable, Identifiable {
    let _id: String
    let titulo: String
    let distancia: String
    let tiempo: String
    let nivel: String
    let coordenadas: [Coordenada]
    let __v: Int
    
    // Computed property para cumplir con Identifiable
    var id: String { _id }
}

struct Coordenada: Codable, Identifiable {
    let latitud: Double
    let longitud: Double
    let tipo: String
    let _id: String
    
    var id: String { _id }
}
