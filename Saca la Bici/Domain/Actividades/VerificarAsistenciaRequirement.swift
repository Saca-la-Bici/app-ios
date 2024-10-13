//
//  VerificarAsistenciaRequirement.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 12/10/24.
//

import Foundation

// Creas el protocolo de la historia de usuario
protocol VerificarAsistenciaRequirementProtocol {
    func verificarAsistencia(IDRodada: String, codigo: String) async -> AsistenciaResponse?
}

class VerificarAsistenciaRequirement: VerificarAsistenciaRequirementProtocol {

    // Singleton para que lo use el Requirement
    static let shared = VerificarAsistenciaRequirement()

    let actividadesRepository: ActividadesRepository

    // Inicializas la instancia con el repositorio que acaba se crearse
    init(actividadesRepository: ActividadesRepository = ActividadesRepository.shared) {
        self.actividadesRepository = actividadesRepository
    }

    func verificarAsistencia(IDRodada: String, codigo: String) async -> AsistenciaResponse? {
        return await actividadesRepository.verificarAsistencia(IDRodada: IDRodada, codigo: codigo)
    }
}
