//
//  LoginRequirement.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import Foundation
import AuthenticationServices

// Creas el protocolo de la historia de usuario
protocol LoginRequirementProtocol {
    func iniciarSesion(UserDatos: User) async -> Int?
    func GoogleLogin() async -> Int?
    func AppleLogin(authorization: ASAuthorization, nonce: String) async -> Int
}

class LoginRequirement: LoginRequirementProtocol {
    
    // Singleton para que lo use el Requirement
    static let shared = LoginRequirement()
    
    // La variable inmutable es de tipo Pokemon Repository
    let sessionRepository: SessionRepository
    
    // Inicializas la instancia con el repositorio que acaba se crearse
    init(sessionRepository: SessionRepository = SessionRepository.shared) {
        self.sessionRepository = sessionRepository
    }
    
    func iniciarSesion(UserDatos: User) async -> Int? {
        return await sessionRepository.iniciarSesion(UserDatos: UserDatos)
    }
    
    func GoogleLogin() async -> Int? {
        return await sessionRepository.GoogleLogin()
    }
    
    func AppleLogin(authorization: ASAuthorization, nonce: String) async -> Int {
        return await sessionRepository.AppleLogin(authorization: authorization, nonce: nonce)
    }
    
}
