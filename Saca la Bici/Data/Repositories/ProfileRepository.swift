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
        
        // let url = URL(string: "\(Api.base)\(Api.Routes.profile)/consultar")!
        let url = URL(string: "\(Api.base)\(Api.Routes.profile)/consultar")!
        
        var profile: Profile
        
        do {
            print("voy a intentar de api a repo")
            profile = try await profileAPIService.consultarPerfilPropio(url: url)
            print("Paso de api a repo")
        } catch {
            print("No paso de api a repo")
            throw error
        }
        return profile
    }
    
}
