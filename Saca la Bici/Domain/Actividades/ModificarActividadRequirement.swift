//
//  ModificarActividadRequirement.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 11/10/24.
//

import Foundation

// Protocolo
protocol ModificarActividadRequirementProtocol {
    func consultarActividadIndividual(actividadId: String) async -> ActividadIndividualResponse?
}

class ModificarActividadRequirement: ModificarActividadRequirementProtocol {
    
    // Signeton
    static let shared = ModificarActividadRequirement()
    
    // Repository
    let repository: ActividadesRepository
    
    init (repository: ActividadesRepository = ActividadesRepository()) {
        self.repository = repository
    }
    
    // Obtener datos de actividad a modificar
    func consultarActividadIndividual(actividadId: String) async -> ActividadIndividualResponse? {
        return await repository.consultarActividadIndividual(actividadID: actividadId)
    }
    
}
