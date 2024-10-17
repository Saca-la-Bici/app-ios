//
//  ConsultarMedallasRequirement.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 15/10/24.
//

import Foundation

protocol ConsultarMedallasRequirementProtocol {
    func consultarMedallas() async throws -> [Medalla]
}

class ConsultarMedallasRequirement: ConsultarMedallasRequirementProtocol {
    
    private let repository: MedallasRepositoryProtocol
    
    init(repository: MedallasRepositoryProtocol) {
        self.repository = repository
    }
    
    func consultarMedallas() async throws -> [Medalla] {
        do {
            let medallas = try await repository.consultarMedallas()
            return medallas
        } catch {
            throw error
        }
    }
}
