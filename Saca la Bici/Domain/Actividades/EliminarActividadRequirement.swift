//
//  EliminarActividadRequirement.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 09/10/24.
//

import Foundation

// Protocolo
protocol EliminarActividadRequirementProtocol {
    func eliminarActividad(id: String, tipo: String) async throws -> EliminarActividadResponse
}

// Requirement
class EliminarActividadRequirement: EliminarActividadRequirementProtocol {
    
    // Singleton
    static let shared = EliminarActividadRequirement()
    
    // Repository
    let repository: ActividadesRepository
    
    init(repository: ActividadesRepository = ActividadesRepository()) {
        self.repository = repository
    }
    
    func eliminarActividad(id: String, tipo: String) async throws -> EliminarActividadResponse {
        return try await repository.eliminarActividad(id: id, tipo: tipo)
    }
    
}
