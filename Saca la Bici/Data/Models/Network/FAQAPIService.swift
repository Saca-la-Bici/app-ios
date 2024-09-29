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
    
    // Fetch FAQs
    func fetchFAQs(url: URL) async throws -> FAQResponse {
        
        let headers: HTTPHeaders = [
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

