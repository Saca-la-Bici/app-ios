//
//  ModificarPerfilRequirement.swift
//  Saca la Bici
//
//  Created by Diego Lira on 14/10/24.
//

class ModificarPerfilRequirement {
    
    let profileRepository = ProfileRepository()
    
    private var resultado: String = ""
    
    func modificarPerfil(nombre: String, username: String, tipoSangre: String, numeroEmergencia: String) async throws -> String {
        
        do {
            resultado = try await profileRepository.modificarPerfil(
                nombre: nombre, username: username,
                tipoSangre: tipoSangre, numeroEmergencia: numeroEmergencia)
            
        } catch {
            throw error
        }
        
        return resultado
    }
    
}
