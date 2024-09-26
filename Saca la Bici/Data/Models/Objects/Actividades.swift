//
//  Actividades.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import Foundation

struct RodadasResponse: Codable {
    let _id: String
    let informacion: [Actividad]
    let ruta: Ruta
}

struct EventosResponse: Codable {
    let _id: String
    let informacion: [Actividad]
}

struct TalleresResponse: Codable {
    let _id: String
    let informacion: [Actividad]
}

struct Actividad: Codable, Identifiable {
    let _id: String
    let titulo: String
    let fecha: String
    let hora: String
    let personasInscritas: Int
    let ubicacion: String
    let descripcion: String
    let estado: Bool
    let duracion: String
    let imagen: String?
    let tipo: String
    let comentarios: String?
    
    var id: String { _id }
}

struct Ruta: Codable {
    let _id: String
    let titulo: String
    let distancia: String
    let tiempo: String
    let nivel: String
    let coordenadas: [Coordenada]
    let __v: Int
}

struct Coordenada: Codable, Identifiable {
    let latitud: Double
    let longitud: Double
    let tipo: String
    let _id: String
    
    var id: String { _id }
}
