//
//  FAQAPIService.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Alamofire
import Foundation
import FirebaseAuth

class FAQAPIService {
    
    let firebaseTokenManager: FirebaseTokenManager
    
    init(firebaseTokenManager: FirebaseTokenManager = FirebaseTokenManager.shared) {
            self.firebaseTokenManager = firebaseTokenManager
        }
    
    // Fetch FAQs
    func fetchFAQs(url: URL) async throws -> FAQResponse {
        
        guard let idToken = await firebaseTokenManager.obtenerIDToken() else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID Token"])
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(idToken)",
            "Content-Type": "application/json"
        ]
        
        do {
            let response = try await AF.request(url, method: .get, headers: headers)
                .validate()
                .serializingDecodable(FAQResponse.self)
                .value
            
            return response
        } catch {
            print("Error al obtener FAQs: \(error)")
            throw error
        }
    }
}

