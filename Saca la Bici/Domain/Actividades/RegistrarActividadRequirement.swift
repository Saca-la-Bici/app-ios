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
    func getRutas() async -> RutasResponse?
}

class RegistrarActividadRequirement: RegistrarActividadRequirementProtocol {

    // Singleton para que lo use el Requirement
    static let shared = RegistrarActividadRequirement()

    let actividadesRepository: ActividadesRepository
    let rutasRepository: RutasRepository

    // Inicializas la instancia con el repositorio que acaba se crearse
    init(actividadesRepository: ActividadesRepository = ActividadesRepository.shared,
         rutasRepository: RutasRepository = RutasRepository.shared) {
        self.actividadesRepository = actividadesRepository
        self.rutasRepository = rutasRepository
    }

    func registrarActividad(actividad: DatosActividad) async throws -> Int? {
        return try await actividadesRepository.registrarActividad(actividad: actividad)
    }
    
    func getRutas() async -> RutasResponse? {
        return await rutasRepository.getRutas()
    }

}
