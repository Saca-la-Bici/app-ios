//
//  FAQRepository.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Foundation

class FAQRepository {
    
    // Singleton
    private let apiService: FAQAPIService
    
    // Inicializar Singleton
    init(apiService: FAQAPIService = FAQAPIService()) {
        self.apiService = apiService
    }
    
    // Get FAQs
    func getFAQs() async throws -> FAQResponse {
        let response = try await apiService.fetchFAQs(url: URL(string: "\(Api.base)\(Api.Routes.faq)/consultar")!)
        
        return response
    }
    
    
}
