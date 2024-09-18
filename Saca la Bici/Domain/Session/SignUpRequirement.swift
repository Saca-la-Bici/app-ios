//
//  SignUpRequirement.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import Foundation

// Creas el protocolo de la historia de usuario
protocol SignUpRequirementProtocol {
    func registrarUsuario(UserDatos: UserNuevo) async -> Int?
    func checarPerfilBackend() async -> Bool
    func completarPerfil(UserDatos: UserExterno) async -> Int?
}

class SignUpRequirement : SignUpRequirementProtocol {
    
    // Singleton para que lo use el Requirement
    static let shared = SignUpRequirement()
    
    // La variable inmutable es de tipo Pokemon Repository
    let sessionRepository: SessionRepository
    
    // Inicializas la instancia con el repositorio que acaba se crearse
    init(sessionRepository: SessionRepository = SessionRepository.shared) {
        self.sessionRepository = sessionRepository
    }
    
    func registrarUsuario(UserDatos: UserNuevo) async -> Int? {
        return await sessionRepository.registrarUsuario(UserDatos: UserDatos)
    }
    
    func checarPerfilBackend() async -> Bool {
        return await sessionRepository.checarPerfilBackend()
    }
    
    func completarPerfil(UserDatos: UserExterno) async -> Int? {
        return await sessionRepository.completarPerfil(UserDatos: UserDatos)
    }
    
}
