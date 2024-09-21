//
//  LoginRepository.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation
import AuthenticationServices

// Se crea el protocolo para que lo hereden la clase o el struct (como la base)
protocol SessionAPIProtocol {
    
    func registrarUsuario(UserDatos: UserNuevo) async -> Int?
    func probarToken() async -> Response?
    func iniciarSesion(UserDatos: User) async -> Int?
    func checarPerfilBackend() async throws -> Response
    func completarPerfil(UserDatos: UserExterno) async -> Int?
    func verificarUsernameExistente(username: String) async -> Bool?
    func GoogleLogin() async -> Int?
    func AppleLogin(authorization: ASAuthorization, nonce: String) async -> Int
}

// Crear nuestra clase PokemonRespository y heredar de nuestro protocolo PokemonAPIProtocol
class SessionRepository: SessionAPIProtocol {
    
    // Singleton para que cada requerimiento pueda acceder al mismo archivo y clase (repositiorio con funciones de llamadas API
    static let shared = SessionRepository()
    
    // Se crea la variable tipo NetworkAPIService con la librería Alamofire
    let sessionService: SessionAPIService
    
    // Se inicializa con la variable singleton
    init(sessionService: SessionAPIService = SessionAPIService.shared) {
            self.sessionService = sessionService
        }
    
    func registrarUsuario(UserDatos: UserNuevo) async -> Int? {
        return await sessionService.registrarUsuario(url: URL(string:"\(Api.base)\(Api.routes.session)/registrarUsuario")!, UserDatos: UserDatos)
    }
    
    func probarToken() async -> Response? {
        // Llamas la función usando el URL base, el modulo y limite que fue pasado usando await porque es asincronico
        return await sessionService.probarToken(url: URL(string:"\(Api.base)")!)
    }
    
    // Tomar en cuenta la llamada al back para mostrar info
    func iniciarSesion(UserDatos: User) async -> Int? {
        return await sessionService.iniciarSesion(UserDatos: UserDatos, URLUsername: URL(string:"\(Api.base)\(Api.routes.session)/getUserEmail")!)
    }
    
    func checarPerfilBackend() async throws -> Response {
        return try await sessionService.checarPerfilBackend(url: URL(string:"\(Api.base)\(Api.routes.session)/perfilCompleto")!)
    }
    
    func completarPerfil(UserDatos: UserExterno) async -> Int? {
        return await sessionService.completarPerfil(url: URL(string:"\(Api.base)\(Api.routes.session)/registrarUsuario")!, UserDatos: UserDatos)
    }
    
    func verificarUsernameExistente(username: String) async -> Bool? {
        return await sessionService.verificarUsernameExistente(username: username, URLUsername: URL(string:"\(Api.base)\(Api.routes.session)/getUsername")!)
    }
    
    func GoogleLogin() async -> Int? {
        return await sessionService.GoogleLogin(url: URL(string:"\(Api.base)\(Api.routes.session)/registrarUsuario")!)
    }
    
    func AppleLogin(authorization: ASAuthorization, nonce: String) async -> Int {
        return await sessionService.AppleLogin(authorization: authorization, nonce: nonce)
    }
}
