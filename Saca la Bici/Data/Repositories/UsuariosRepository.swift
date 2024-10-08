//
//  ConsultarUsuariosRepository.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import Foundation

class UsuariosRepository {
    
    static let shared = UsuariosRepository()
    
    private let usuariosAPIService: UsuariosApiService
    
    init(usuariosAPIService: UsuariosApiService = UsuariosApiService.shared) {
        self.usuariosAPIService = usuariosAPIService
    }

    func obtenerUsuarios(page: Int, limit: Int, roles: [String]) async throws -> ConsultarUsuariosResponse {
        return try await usuariosAPIService.consultarUsuarios(
            page: page, limit: limit, roles: roles, url: "\(Api.base)\(Api.Routes.profile)/consultarUsuarios")
    }
    
    func buscadorUsuarios(page: Int, limit: Int, roles: [String], search: String) async throws -> ConsultarUsuariosResponse {
        return try await usuariosAPIService.buscadorUsuarios(
            page: page, limit: limit, roles: roles, url: "\(Api.baseURL)\(Api.Routes.profile)/consultarUsuariosBuscador", search: search)
    }
    
    func modifyRole(idRol: String, idUsuario: String) async -> Int? {
        return await usuariosAPIService.modifyRole(
            url: URL(string: "\(Api.base)\(Api.Routes.profile)/modificarRol/\(idUsuario)")!, idRol: idRol)
    }
    
    func getUserRoles() async -> [Rol]? {
        return await usuariosAPIService.getUserRoles(
            url: URL(string: "\(Api.base)\(Api.Routes.profile)/getAllRoles")!)
    }
}
