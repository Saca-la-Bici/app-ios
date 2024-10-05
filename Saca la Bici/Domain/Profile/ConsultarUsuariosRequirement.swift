//
//  ConsultarUsuariosRequirement.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import Foundation

class GetUsuariosUseCase {
    private let repository: ConsultarUsuariosRepository

    init(repository: ConsultarUsuariosRepository = ConsultarUsuariosRepository()) {
        self.repository = repository
    }

    func execute(page: Int, limit: Int, roles: [String]) async throws -> [ConsultarUsuario] {
        return try await repository.obtenerUsuarios(page: page, limit: limit, roles: roles, url: "\(Api.base)/perfil/consultarUsuarios")
    }
}
