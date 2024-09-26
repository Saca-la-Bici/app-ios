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
    func reauthenticateUser(currentPassword: String) async -> Bool
    func restablecerContraseña(newPassword: String) async -> Bool
    func emailRestablecerContraseña(emailOrUsername: String) async -> Bool
}

// Crear nuestra clase PokemonRespository y heredar de nuestro protocolo PokemonAPIProtocol
class SessionRepository: SessionAPIProtocol {
    
    // Singleton para que cada requerimiento pueda acceder al mismo archivo y clase (repositiorio con funciones de llamadas API
    static let shared = SessionRepository()
    
    // Se crea la variable tipo NetworkAPIService con la librería Alamofire
    let sessionService: SessionAPIService
    
    let userProfileService: UserProfileSessionAPIService
    
    // Se inicializa con la variable singleton
    init(sessionService: SessionAPIService = SessionAPIService.shared,
         userProfileService: UserProfileSessionAPIService = UserProfileSessionAPIService.shared) {
            self.sessionService = sessionService
            self.userProfileService = userProfileService
        }
    
    func registrarUsuario(UserDatos: UserNuevo) async -> Int? {
        return await sessionService.registrarUsuario(url: URL(string: "\(Api.base)\(Api.Routes.session)/registrarUsuario")!, UserDatos: UserDatos)
    }
    
    func probarToken() async -> Response? {
        // Llamas la función usando el URL base, el modulo y limite que fue pasado usando await porque es asincronico
        return await sessionService.probarToken(url: URL(string: "\(Api.base)")!)
    }
    
    // Tomar en cuenta la llamada al back para mostrar info
    func iniciarSesion(UserDatos: User) async -> Int? {
        return await sessionService.iniciarSesion(UserDatos: UserDatos,
                                                  URLUsername: URL(string: "\(Api.base)\(Api.Routes.session)/getUserEmail")!,
                                                  url: URL(string: "\(Api.base)")!)
    }
    
    func checarPerfilBackend() async throws -> Response {
        return try await userProfileService.checarPerfilBackend(url: URL(string: "\(Api.base)\(Api.Routes.session)/perfilCompleto")!)
    }
    
    func completarPerfil(UserDatos: UserExterno) async -> Int? {
        return await userProfileService.completarPerfil(url: URL(string: "\(Api.base)\(Api.Routes.session)/registrarUsuario")!, UserDatos: UserDatos)
    }
    
    func verificarUsernameExistente(username: String) async -> Bool? {
        return await userProfileService.verificarUsernameExistente(
            username: username, URLUsername: URL(string: "\(Api.base)\(Api.Routes.session)/getUsername")!)
    }
    
    func GoogleLogin() async -> Int? {
        return await sessionService.GoogleLogin(url: URL(string: "\(Api.base)\(Api.Routes.session)/registrarUsuario")!)
    }
    
    func AppleLogin(authorization: ASAuthorization, nonce: String) async -> Int {
        return await sessionService.AppleLogin(authorization: authorization, nonce: nonce)
    }
    
    func reauthenticateUser(currentPassword: String) async -> Bool {
        return await sessionService.reauthenticateUser(currentPassword: currentPassword)
    }
    
    func restablecerContraseña(newPassword: String) async -> Bool {
        return await sessionService.restablecerContraseña(newPassword: newPassword)
    }
    
    func emailRestablecerContraseña(emailOrUsername: String) async -> Bool {
        return await sessionService.emailRestablecerContraseña(
            URLUsername: URL(string: "\(Api.base)\(Api.Routes.session)/getUserEmail")!, emailOrUsername: emailOrUsername)
    }
}
