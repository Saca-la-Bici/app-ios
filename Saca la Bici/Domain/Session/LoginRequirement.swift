//
//  LoginRequirement.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation

// Creas el protocolo de la historia de usuario
protocol LoginRequirementProtocol {
    // El protocolo con las 2 funciones a llamar
    func probarToken() async -> Response?
    func GoogleLogin() async -> Int?
    func iniciarSesion(UserDatos: User) async -> Int?
}

class LoginRequirement : LoginRequirementProtocol {
    
    // Singleton para que lo use el Requirement
    static let shared = LoginRequirement()
    
    // La variable inmutable es de tipo Pokemon Repository
    let loginRepository: LoginRepository
    
    // Inicializas la instancia con el repositorio que acaba se crearse
    init(loginRepository: LoginRepository = LoginRepository.shared) {
        self.loginRepository = loginRepository
    }
    
    func probarToken() async -> Response? {
        return await loginRepository.probarToken()
    }
    
    func iniciarSesion(UserDatos: User) async -> Int? {
        return await loginRepository.iniciarSesion(UserDatos: UserDatos)
    }
    
    func GoogleLogin() async -> Int? {
        return await loginRepository.GoogleLogin()
    }
    
}
