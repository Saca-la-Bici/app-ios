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
        "Condiciones de Participación y Asistencia",
        "Equipamiento",
        "Lugares y tiempos de las rodadas",
        "Medidas de Seguridad",
        "Niveles"
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
    
    // Enum para manejar las alertas activas
    enum ActiveAlert: Identifiable {
        case error
        case success

        var id: Int {
            hashValue
        }
    }
    
    // Estado de alerta
    @Published var activeAlert: ActiveAlert?
    
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
            
            _ = try await repository.updateFAQ(faqUpdated)
            self.successMessage = "Pregunta editada exitosamente."
            self.activeAlert = .success
        } catch {
            self.handleError(error)
        }
        
    }
    
    // Manejo de errores
    private func handleError(_ error: Error) {
        if let afError = error as? AFError {
            switch afError.responseCode {
            case 401:
                self.errorMessage = "No está autorizado para realizar esta acción. Por favor, inicia sesión nuevamente."
            default:
                self.errorMessage = "Hubo un error al editar la pregunta. Favor de intentarlo de nuevo."
            }
        } else {
            self.errorMessage = "Hubo un error al editar la pregunta. Favor de intentarlo de nuevo."
        }
        self.activeAlert = .error
    }
    
}
