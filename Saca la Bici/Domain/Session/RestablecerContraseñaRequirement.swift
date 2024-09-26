//
//  RestablecerContraseñaRequirement.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 24/09/24.
//

import Foundation

// Creas el protocolo de la historia de usuario
protocol RestablecerContraseñaRequirementProtocol {
    
    func reauthenticateUser(currentPassword: String) async -> Bool
    func restablecerContraseña(newPassword: String) async -> Bool
}

class RestablecerContraseñaRequirement: RestablecerContraseñaRequirementProtocol {
    
    // Singleton para que lo use el Requirement
    static let shared = RestablecerContraseñaRequirement()
    
    // La variable inmutable es de tipo Pokemon Repository
    let sessionRepository: SessionRepository
    
    // Inicializas la instancia con el repositorio que acaba se crearse
    init(sessionRepository: SessionRepository = SessionRepository.shared) {
        self.sessionRepository = sessionRepository
    }
    
    func reauthenticateUser(currentPassword: String) async -> Bool {
        return await sessionRepository.reauthenticateUser(currentPassword: currentPassword)
    }
    
    func restablecerContraseña(newPassword: String) async -> Bool {
        return await sessionRepository.restablecerContraseña(newPassword: newPassword)
    }
    
}
