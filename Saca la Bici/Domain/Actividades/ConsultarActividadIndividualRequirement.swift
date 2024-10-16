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
}
