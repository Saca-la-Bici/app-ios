//
//  ModificarPerfilRequirement.swift
//  Saca la Bici
//
//  Created by Diego Lira on 14/10/24.
//

import Foundation

class ModificarPerfilRequirement {
    
    let profileRepository = ProfileRepository()
    
    private var resultado: String = ""
    
    let sessionRepository: SessionRepository
    
    init(sessionRepository: SessionRepository = SessionRepository.shared) {
        self.sessionRepository = sessionRepository
    }
    
    func modificarPerfil(nombre: String, username: String, tipoSangre: String, numeroEmergencia: String, imagen: Data?) async throws -> String {
        
        do {
            resultado = try await profileRepository.modificarPerfil(
                nombre: nombre, username: username,
                tipoSangre: tipoSangre, numeroEmergencia: numeroEmergencia, imagen: imagen)
            
        } catch {
            throw error
        }
        
        return resultado
    }
    
    func verificarUsernameExistente(username: String) async -> Bool? {
        return await sessionRepository.verificarUsernameExistente(username: username)
    }
    
}
