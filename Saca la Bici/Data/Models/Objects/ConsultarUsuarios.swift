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
struct ConsultarUsuario: Codable, Identifiable {
    let id = UUID()
    let usuario: ConsultarUsuarioDatos
    let rol: ConsultarUsuarioRol
}

// Detalles del usuario
struct ConsultarUsuarioDatos: Codable {
    let id: String
    let username: String
    let nombre: String
    let correoElectronico: String
    let imagenPerfil: String?
}

// Rol del usuario
struct ConsultarUsuarioRol: Codable {
    let id: String
    let nombreRol: String
}
