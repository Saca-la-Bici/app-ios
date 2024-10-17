//
//  InscribirActividadRequirement.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 06/10/24.
//

import Foundation

// Nuevo protocolo para acciones de inscripción y cancelación
protocol GestionarAsistenciaRequirementProtocol {
    func inscribirActividad(actividadId: String, tipo: String) async throws -> ActionResponse
    func cancelarAsistencia(actividadId: String, tipo: String) async throws -> ActionResponse
}

class GestionarAsistenciaRequirement: GestionarAsistenciaRequirementProtocol {

    // Singleton para que lo use el Requirement
    static let shared = GestionarAsistenciaRequirement()

    let actividadesRepository: ActividadesRepository

    // Inicializas la instancia con el repositorio que acaba se crearse
    init(actividadesRepository: ActividadesRepository = ActividadesRepository.shared) {
        self.actividadesRepository = actividadesRepository
    }

    func inscribirActividad(actividadId: String, tipo: String) async throws -> ActionResponse {
        return try await actividadesRepository.inscribirActividad(actividadId: actividadId, tipo: tipo)
    }

    func cancelarAsistencia(actividadId: String, tipo: String) async throws -> ActionResponse {
        return try await actividadesRepository.cancelarAsistencia(actividadId: actividadId, tipo: tipo)
    }
}
