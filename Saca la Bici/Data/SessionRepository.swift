//
//  LoginRepository.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation

// Se crea el protocolo para que lo hereden la clase o el struct (como la base)
protocol SessionAPIProtocol {
    
    func registrarUsuario(UserDatos: UserNuevo) async -> Int?
        
    func probarToken() async -> Response?
    
    func GoogleLogin() async -> Int?
    
    func iniciarSesion(UserDatos: User) async -> Int?
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
        return await sessionService.registrarUsuario(url: URL(string:"\(Api.base)\(Api.routes.session)/registrarUsuario")!, UserDatos: UserDatos, urlStatus: URL(string:"\(Api.base)\(Api.routes.status)")!)
    }
    
    func probarToken() async -> Response? {
        // Llamas la función usando el URL base, el modulo y limite que fue pasado usando await porque es asincronico
        return await sessionService.probarToken(url: URL(string:"\(Api.base)")!)
    }
    
    // Tomar en cuenta la llamada al back para mostrar info
    func iniciarSesion(UserDatos: User) async -> Int? {
        return await sessionService.iniciarSesion(UserDatos: UserDatos, URLUsername: URL(string:"\(Api.base)\(Api.routes.session)/getUserEmail")!)
    }
    
    func GoogleLogin() async -> Int? {
        return await sessionService.GoogleLogin(url: URL(string:"\(Api.base)\(Api.routes.session)/registrarUsuario")!)
    }
}
