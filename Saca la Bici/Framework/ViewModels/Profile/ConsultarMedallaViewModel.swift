//
//  ConsultarMedallaViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 15/10/24.
//

import Foundation
import SwiftUI

@MainActor
class MedalsViewModel: ObservableObject {
    @Published var medallas: [Medalla] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let consultarMedallasRequirement: ConsultarMedallasRequirementProtocol
    
    init(consultarMedallasRequirement: ConsultarMedallasRequirementProtocol = ConsultarMedallasRequirement(repository: MedallasRepository())) {
        self.consultarMedallasRequirement = consultarMedallasRequirement
    }
    
    func fetchMedallas() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let medallasObtenidas = try await consultarMedallasRequirement.consultarMedallas()
                self.medallas = medallasObtenidas
            } catch {
                self.errorMessage = "No se pudieron cargar las medallas: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}
