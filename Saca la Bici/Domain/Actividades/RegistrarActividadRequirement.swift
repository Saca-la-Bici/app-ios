//
//  RegistrarActividadRequierement.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 30/09/24.
//

import Foundation

// Creas el protocolo de la historia de usuario
protocol RegistrarActividadRequirementProtocol {
    func registrarActividad(actividad: DatosActividad) async throws -> Int?
}

class RegistrarActividadRequirement: RegistrarActividadRequirementProtocol {

    // Singleton para que lo use el Requirement
    static let shared = RegistrarActividadRequirement()

    // La variable inmutable es de tipo Pokemon Repository
    let actividadesRepository: ActividadesRepository

    // Inicializas la instancia con el repositorio que acaba se crearse
    init(actividadesRepository: ActividadesRepository = ActividadesRepository.shared) {
        self.actividadesRepository = actividadesRepository
    }

    func registrarActividad(actividad: DatosActividad) async throws -> Int? {
        return try await actividadesRepository.registrarActividad(actividad: actividad)
    }

}
