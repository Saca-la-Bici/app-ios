//
//  Profile.swift
//  Saca la Bici
//
//  Created by Diego Lira on 25/09/24.
//

import Foundation

struct Profile: Codable {
    let username: String
    let nombre: String?
    let fechaNacimiento: String?
    var tipoSangre: String?
    let imagen: String?
    let correoElectronico: String
    let numeroEmergencia: String?
    let fechaRegistro: String?
    let kilometrosRecorridos: Double
    let tiempoEnRecorrido: Double
    let rodadasCompletadas: Int
    let firebaseUID: String
}
