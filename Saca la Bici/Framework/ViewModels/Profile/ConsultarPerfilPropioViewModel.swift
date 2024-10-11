//
//  ConsultarPerfilPropioViewModel.swift
//  Saca la Bici
//
//  Created by Diego Lira on 24/09/24.
//

import Foundation
import FirebaseAuth

class ConsultarPerfilPropioViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var isLoading: Bool = true
    @Published var error: Error?
    @Published var errorMessage: String?
    
    let consultarPerfilPropioRequirement = ConsultarPerfilPropioRequirement()
    
    @MainActor
    func consultarPerfilPropio() async throws {
        self.isLoading = true
        do {
            
            self.profile = try await consultarPerfilPropioRequirement.consultarPerfilPropio()
        } catch {
            self.errorMessage = "Hubo un error al ingresar a tu perfil, intente de nuevo más tarde"
            
            // Manejo del error en caso de que algo falle
            print("Error: \(error.localizedDescription)")
            throw error
        }
        self.isLoading = false
    }
    
}
