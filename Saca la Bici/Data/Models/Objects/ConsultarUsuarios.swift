//
//  ConsultarUsuarios.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import Foundation

// Modelo que representa la respuesta del API
struct ConsultarUsuariosResponse: Codable {
    let usuarios: [ConsultarUsuario]
    let currentPage: Int
    let totalUsuarios: Int
    let totalPages: Int
}

// Modelo que representa a un usuario
struct ConsultarUsuario: Codable, Identifiable, Equatable {
    var id: String { usuario.id }
    let usuario: ConsultarUsuarioDatos
    let rol: ConsultarUsuarioRol

    static func == (lhs: ConsultarUsuario, rhs: ConsultarUsuario) -> Bool {
        return lhs.id == rhs.id
    }
}

// Detalles del usuario
struct ConsultarUsuarioDatos: Codable, Equatable {
    let id: String
    let username: String
    let nombre: String
    let correoElectronico: String
    let imagenPerfil: String?
}

// Rol del usuario
struct ConsultarUsuarioRol: Codable, Equatable {
    let id: String
    let nombreRol: String
}
