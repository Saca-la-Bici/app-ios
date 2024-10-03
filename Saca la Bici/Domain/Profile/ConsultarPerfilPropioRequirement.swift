//
//  ConsultarPerfilPropioRequirement.swift
//  Saca la Bici
//
//  Created by Diego Lira on 25/09/24.
//

class ConsultarPerfilPropioRequirement {
    
    let profileRepository = ProfileRepository()
    
    func consultarPerfilPropio() async throws -> Profile {
      
        var profile: Profile
        
        do {
            print("Entre a el do de requi")
            profile = try await profileRepository.consultarPerfilPropio()
            print("Paso de repo a requi")
            
        } catch {
            print("Entre a el catch de requi")
            print("Error: \(error.localizedDescription)")
            throw error
        }
        
        return profile
        
    }
}
