//
//  ConsultarActividadIndividualRequirement.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 04/10/24.
//

import Foundation

// Creas el protocolo de la historia de usuario
protocol ConsultarActividadIndRequirementProtocol {
    func consultarActividadIndividual(actividadID: String) async -> ActividadIndividualResponse?
    func inscribirActividad(actividadId: String, tipo: String) async throws -> ActionResponse
    func cancelarAsistencia(actividadId: String, tipo: String) async throws -> ActionResponse
}

class ConsultarActividadIndividualRequirement: ConsultarActividadIndRequirementProtocol {

    // Singleton para que lo use el Requirement
    static let shared = ConsultarActividadIndividualRequirement()

    let actividadesRepository: ActividadesRepository

    // Inicializas la instancia con el repositorio que acaba se crearse
    init(actividadesRepository: ActividadesRepository = ActividadesRepository.shared) {
        self.actividadesRepository = actividadesRepository
    }

    func consultarActividadIndividual(actividadID: String) async -> ActividadIndividualResponse? {
        return await actividadesRepository.consultarActividadIndividual(actividadID: actividadID)
    }
    
    func inscribirActividad(actividadId: String, tipo: String) async throws -> ActionResponse {
        return try await actividadesRepository.inscribirActividad(actividadId: actividadId, tipo: tipo)
    }

    func cancelarAsistencia(actividadId: String, tipo: String) async throws -> ActionResponse {
        return try await actividadesRepository.cancelarAsistencia(actividadId: actividadId, tipo: tipo)
    }
}
