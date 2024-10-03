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
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    let consultarPerfilPropioRequirement = ConsultarPerfilPropioRequirement()
    
    @MainActor
    func consultarPerfilPropio() async throws {
        
        do {
            print("Entre a el do de VIewModel")
            self.profile = try await consultarPerfilPropioRequirement.consultarPerfilPropio()
            
            // Accede a las propiedades del objeto `Profile`
            print("Si paso de requirment a viewmodel")
            
            } catch {
            print("Entre al catch de viewModel")
            // Manejo del error en caso de que algo falle
            print("Error: \(error.localizedDescription)")
            throw error
        }
        
    }
    
}
