//
//  ProfileRepository.swift
//  Saca la Bici
//
//  Created by Diego Lira on 25/09/24.
//

import Foundation

class ProfileRepository {
    
    let profileAPIService = ProfileAPIService()
    
    func consultarPerfilPropio() async throws -> Profile {
        
        let url = URL(string: "\(Api.base)\(Api.Routes.profile)/consultar")!
        
        var profile: Profile
        
        do {
            profile = try await profileAPIService.consultarPerfilPropio(url: url)
        } catch {
            throw error
        }
        return profile
    }
    
}
