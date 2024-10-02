//
//  AddFAQViewModel.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Alamofire
import Foundation

@MainActor
class AddFAQViewModel: ObservableObject {
    
    // Temas
    @Published var temasList: [String] = [
        "Condiciones de Participación y Asistencia",
        "Equipamiento",
        "Lugares y tiempos de las rodadas",
        "Medidas de Seguridad",
        "Niveles"
    ]
    
    // Variables
    @Published var temaSelected: String = "Condiciones de Participación y Asistencia"
    @Published var pregunta: String = ""
    @Published var respuesta: String = ""
    
    // Manejo de errores
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
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
    
    // Singleton del repositorio
    let repository: FAQRepository
    
    // Inicializar
    init(repository: FAQRepository = FAQRepository()) {
        self.repository = repository
    }
    
    func addFAQ(tema: String, pregunta: String, respuesta: String) async {
        
        do {
            // Obtener ultimo ID
            let lastID = try await repository.getFAQs().data.last?.IdPregunta ?? 0
            
            // Crear nuevo FAQ
            let newFAQ = FAQ(
                IdPregunta: lastID + 1,
                Pregunta: pregunta,
                Respuesta: respuesta,
                Tema: tema,
                Imagen: "")
            
            // Crear FAQ en la base de datos
            _ = try await repository.addFAQ(newFAQ)
            self.successMessage = "Pregunta creada exitosamente."
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
                self.errorMessage = "Hubo un error al registrar la pregunta. Favor de intentarlo de nuevo."
            }
        } else {
            self.errorMessage = "Hubo un error al registrar la pregunta. Favor de intentarlo de nuevo."
        }
        self.activeAlert = .error
    }
}
