//
//  MedallasRepository.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 15/10/24.
//

import Foundation

protocol MedallasRepositoryProtocol {
    func consultarMedallas() async throws -> [Medalla]
}

class MedallasRepository: MedallasRepositoryProtocol {
    let profileAPIService = ProfileAPIService()

    func consultarMedallas() async throws -> [Medalla] {
        let url = URL(string: "\(Api.base)\(Api.Routes.profile)/consultarMedallas")!
        let medallasResponse = try await profileAPIService.consultarMedallas(url: url)
        return medallasResponse.medallasActivas
    }
}
