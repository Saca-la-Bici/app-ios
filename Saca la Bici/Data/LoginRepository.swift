//
//  LoginRepository.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation

// Se crea el protocolo para que lo hereden la clase o el struct (como la base)
protocol LoginAPIProtocol {
        
    func probarToken() async -> Response?
    
    func GoogleLogin() async -> Int?
    
    func iniciarSesion(UserDatos: User) async -> Int?
}

// Crear nuestra clase PokemonRespository y heredar de nuestro protocolo PokemonAPIProtocol
class LoginRepository: LoginAPIProtocol {
    
    // Singleton para que cada requerimiento pueda acceder al mismo archivo y clase (repositiorio con funciones de llamadas API
    static let shared = LoginRepository()
    
    // Se crea la variable tipo NetworkAPIService con la librería Alamofire
    let loginService: LoginAPIService
    
    // Se inicializa con la variable singleton
    init(loginService: LoginAPIService = LoginAPIService.shared) {
            self.loginService = loginService
        }
    
    func probarToken() async -> Response? {
        // Llamas la función usando el URL base, el modulo y limite que fue pasado usando await porque es asincronico
        return await loginService.probarToken(url: URL(string:"\(Api.base)")!)
    }
    
    // Tomar en cuenta la llamada al back para mostrar info
    func iniciarSesion(UserDatos: User) async -> Int? {
        return await loginService.iniciarSesion(UserDatos: UserDatos, URLUsername: URL(string:"\(Api.base)\(Api.routes.session)/getUserEmail")!)
    }
    
    func GoogleLogin() async -> Int? {
        return await loginService.GoogleLogin(url: URL(string:"\(Api.base)\(Api.routes.session)/registrarUsuario")!)
    }
}
