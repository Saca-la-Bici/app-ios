//
//  UpdateFAQViewModel.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 01/10/24.
//

import Alamofire
import Foundation

@MainActor
class UpdateFAQViewModel: ObservableObject {
    
    // FAQ
    @Published var faq: FAQ?
    
    // Temas
    @Published var temasList: [String] = [
        "Lugares y tiempos de las rodadas",
        "Niveles",
        "Equipamiento",
        "Medidas de Seguridad",
        "Condiciones de Participación y Asistencia"
    ]
    
    
    // Variables
    @Published var temaSelected: String = ""
    @Published var pregunta: String = ""
    @Published var respuesta: String = ""
    
    // Manejo de errores
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    // Singleton del repositorio
    let repository: FAQRepository
    
    // Inicializar
    init(repository: FAQRepository = FAQRepository()) {
        self.repository = repository
    }
    
    // Editar FAQ
    func updateFAQ(idPregunta: Int, pregunta: String, respuesta: String, tema: String) async {
        
        do {
            
            // Crear nuevo FAQ
            let faqUpdated = FAQ(
                IdPregunta: idPregunta,
                Pregunta: pregunta,
                Respuesta: respuesta,
                Tema: tema,
                Imagen: "")
            
            let _ = try await repository.updateFAQ(faqUpdated)
            self.successMessage = "FAQ editada exitosamente."
            
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
