//
//  ConsultarUsuariosRepository.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import Foundation

class ConsultarUsuariosRepository {
    private let apiService: ConsultarUsuariosApiService
    private let url: String = "\(Api.base)\(Api.Routes.profile)/consultarUsuarios"

    init(apiService: ConsultarUsuariosApiService = ConsultarUsuariosApiService()) {
        self.apiService = apiService
    }

    func obtenerUsuarios(page: Int, limit: Int, roles: [String]) async throws -> ConsultarUsuariosResponse {
        return try await apiService.consultarUsuarios(page: page, limit: limit, roles: roles, url: url)
    }
}
