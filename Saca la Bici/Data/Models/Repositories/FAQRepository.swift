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
    
    // Get one FAQ
    func getFAQ(_ id: Int) async throws -> FAQResponse {
        
        print("URL: \(URL(string: "\(Api.base)\(Api.Routes.faq)/consultarIndividual/\(id)")!)")
        
        let response = try await apiService.fetchFAQ(url: URL(string: "\(Api.base)\(Api.Routes.faq)/consultarIndividual/\(id)")!)
        
        return response
    }
    
    // Add FAQ
    func addFAQ(_ faq: FAQ) async throws -> String {
        let responseMsg = try await apiService.addFAQ(url: URL(string: "\(Api.base)\(Api.Routes.faq)/registrar")!, faq: faq)
        
        return responseMsg
    }
    
    // Update FAQ
    func updateFAQ(_ faq: FAQ) async throws -> String {
        let responseMsg = try await apiService.updateFAQ(url: URL(string: "\(Api.base)\(Api.Routes.faq)/modificar/\(faq.IdPregunta)")!, faq: faq)
        
        return responseMsg
    }
    
    
}
