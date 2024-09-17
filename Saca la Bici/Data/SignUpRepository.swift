//
//  SignUpRepository.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import Foundation

// Se crea el protocolo para que lo hereden la clase o el struct (como la base)
protocol SignUpAPIProtocol {
    func registrarUsuario(UserDatos: UserNuevo) async -> Int?
}

class SignUpRepository: SignUpAPIProtocol {
    
    // Singleton para que cada requerimiento pueda acceder al mismo archivo y clase (repositiorio con funciones de llamadas API
    static let shared = SignUpRepository()
    
    // Se crea la variable tipo NetworkAPIService con la librería Alamofire
    let signUpService: SignUpAPIService
    
    // Se inicializa con la variable singleton
    init(signUpService: SignUpAPIService = SignUpAPIService.shared) {
            self.signUpService = signUpService
        }
    
    func registrarUsuario(UserDatos: UserNuevo) async -> Int? {
        return await signUpService.registrarUsuario(url: URL(string:"\(Api.base)\(Api.routes.session)/registrarUsuario")!, UserDatos: UserDatos, urlStatus: URL(string:"\(Api.base)\(Api.routes.status)")!)
    }
    
}
