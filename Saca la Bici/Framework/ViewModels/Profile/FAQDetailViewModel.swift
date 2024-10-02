//
//  FAQDetailViewModel.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 30/09/24.
//

import Alamofire
import Foundation

@MainActor
class FAQDetailViewModel: ObservableObject {
    
    // Variables
    @Published var faq: FAQ?
    
    // Singleton del repositorio
    let repository: FAQRepository
    
    // Manejo de errores
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    // Inicializar
    init(repository: FAQRepository = FAQRepository()) {
        self.repository = repository
    }
    
    // Get FAQ
    func getFAQ(_ id: Int) async {
        do {
            let response = try await repository.getFAQ(id)
            faq = response.data[0]
        } catch {
            self.handleError(error)
        }
        
    }
    
    // Delete FAQ
    func deleteFAQ(_ id: Int) async {
        do {
            _ = try await repository.deleteFAQ(id)
            successMessage = "FAQ eliminada correctamente."
        } catch {
            self.handleError(error)
        }
    }
    
    // Manejo de errores
    private func handleError(_ error: Error) {
        if let afError = error as? AFError {
            switch afError.responseCode {
            case 401:
                self.errorMessage = "No autorizado. Por favor, inicia sesión nuevamente."
            default:
                self.errorMessage = "Error: \(afError.errorDescription ?? "Desconocido")"
            }
        } else {
            self.errorMessage = "Error: \(error.localizedDescription)"
        }
    }
    
}
