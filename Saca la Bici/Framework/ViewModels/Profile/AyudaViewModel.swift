//
//  AyudaViewModel.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Alamofire
import Foundation

class AyudaViewModel: ObservableObject {
    
    // Arrays de preguntas frecuentes
    @Published var faqs: [FAQ] = []
    @Published var temasFAQs: [TemaFAQ] = []
    
    // Manejo de errores
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    // Singleton del repositorio
    let repository: FAQRepository
    
    init(repository: FAQRepository = FAQRepository()) {
        self.repository = repository
    }
    
    
    // Vars
    @Published var searchText: String = ""
    @Published var isSearching: Bool = false
    
    // Obtener preguntas frecuentes
    func getFAQs() async {
        do {
            // Obtener objeto FAQResponse
            let response = try await repository.getFAQs()
            
            // Obtener FAQs desde el campo data
            faqs = response.data
            
            // Lista de temas únicos (FAQ.tema)
            var temas: Set<String> = []
            
            for faq in faqs {
                temas.insert(faq.Tema)
            }
            
            // Agrupar por tema
            let faqsByTema = Dictionary(grouping: faqs, by: { $0.Tema })
            
            // Convertir diccionario en un array de TemaFAQ
            let temasFAQs: [TemaFAQ] = faqsByTema.map { (tema, faqs) in
                return TemaFAQ(tema: tema, faqs: faqs)
            }
            
            // Guardar en variables publicadas
            self.faqs = faqs
            self.temasFAQs = temasFAQs
            
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
