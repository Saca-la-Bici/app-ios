//
//  ConsultarUsuariosRequirement.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import Foundation

class GetUsuariosUseCase {
    private let repository: UsuariosRepository

    init(repository: UsuariosRepository = UsuariosRepository()) {
        self.repository = repository
    }

    func execute(page: Int, limit: Int, roles: [String]) async throws -> ConsultarUsuariosResponse {
        return try await repository.obtenerUsuarios(page: page, limit: limit, roles: roles)
    }
    
    func buscadorUsuarios(page: Int, limit: Int, roles: [String], search: String) async throws -> ConsultarUsuariosResponse {
        return try await repository.buscadorUsuarios(page: page, limit: limit, roles: roles, search: search)
    }
    
    func getUserRoles() async -> [Rol]? {
        return await repository.getUserRoles()
    }
}
