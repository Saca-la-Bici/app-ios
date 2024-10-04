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
            profile = try await profileRepository.consultarPerfilPropio()
            
        } catch {
            print("Error: \(error.localizedDescription)")
            throw error
        }
        
        return profile
        
    }
}
