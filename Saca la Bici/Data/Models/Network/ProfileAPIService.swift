//
//  ProfileAPIService.swift
//  Saca la Bici
//
//  Created by Diego Lira on 25/09/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class ProfileAPIService {
    
    let firebaseTokenManager: FirebaseTokenManager
    
    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
        self.firebaseTokenManager = firebaseTokenManager
    }
    
    func consultarPerfilPropio(url: URL) async throws -> Profile {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
                    throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
                }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        do {
            let profile = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(Profile.self)
                .value
            
            return profile
        } catch {
            print("Error al obtener perfil: \(error.localizedDescription)")
            throw error
        }
        
    }
    
}
