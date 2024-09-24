//
//  BackendModel.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation

struct Response: Codable {
    var message: String?
    var correoElectronico: String?
    var error: String?
}

struct UserNuevo: Codable {
    var username: String
    var password: String
    var nombre: String
    var email: String
    var tipoSangre: String
    var numeroEmergencia: String
}

struct User: Codable {
    var emailorUsername: String
    var password: String
}
