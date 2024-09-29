//
//  AyudaViewModel.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Alamofire
import Foundation
import Combine

class AyudaViewModel: ObservableObject {
    
    // Arrays de preguntas frecuentes
    @Published var faqs: [FAQ] = []
    @Published var temasFAQs: [TemaFAQ] = []
    
    // Para el filtrado
    @Published var searchText: String = ""
    
    // FAQs filtrados
    @Published var filteredFAQs: [TemaFAQ] = []
    
    // Manejo de errores
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    // Combine
    private var cancellables = Set<AnyCancellable>()
    
    // Singleton del repositorio
    let repository: FAQRepository
    
    // Inicializar
    init(repository: FAQRepository = FAQRepository()) {
            self.repository = repository
            
            // Vincular el texto de búsqueda con el filtrado
            $searchText
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .sink { [weak self] searchText in
                    self?.filterFAQs(searchText)
                }
                .store(in: &cancellables)
        }
    
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
    
    // Filtrar FAQs
        private func filterFAQs(_ searchText: String) {
            if searchText.isEmpty {
                // Mostrar todos los FAQs si no hay texto en el campo de búsqueda
                filteredFAQs = temasFAQs
            } else {
                // Filtrar según el texto ingresado
                filteredFAQs = temasFAQs.map { temaFAQ in
                    let faqsFiltrados = temaFAQ.faqs.filter { faq in
                        faq.Pregunta.lowercased().contains(searchText.lowercased())
                    }
                    return TemaFAQ(tema: temaFAQ.tema, faqs: faqsFiltrados)
                }.filter { !$0.faqs.isEmpty } // Remover temas sin FAQs filtrados
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
