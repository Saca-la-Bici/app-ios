//
//  ConsultarUsuariosViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import SwiftUI
import Foundation
import Alamofire

class ConsultarUsuariosViewModel: ObservableObject {
    @Published var usuarios: [ConsultarUsuario] = []
    @Published var roles: [Rol] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var totalUsuarios: Int = 0

    private let getUsuariosUseCase: GetUsuariosUseCase
    private let modificarRolRequirement: ModificarRolRequirement
    private var currentPage: Int = 1
    private let limit: Int = 10

    init(getUsuariosUseCase: GetUsuariosUseCase = GetUsuariosUseCase(), modificarRolRequirement: ModificarRolRequirement = ModificarRolRequirement.shared) {
        self.getUsuariosUseCase = getUsuariosUseCase
        self.modificarRolRequirement = modificarRolRequirement
    }
    
    @MainActor
    func cargarUsuarios(roles: [String]) {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                let response = try await getUsuariosUseCase.execute(page: currentPage, limit: limit, roles: roles)
                usuarios.append(contentsOf: response.usuarios)
                totalUsuarios = response.totalUsuarios
                currentPage += 1
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    @MainActor
    func resetPagination() {
        currentPage = 1
        usuarios = []
    }
    
    @MainActor
    func getRoles() async {
        let roles = await getUsuariosUseCase.getUserRoles()
        
        if roles != nil {
            self.roles = roles!
        }
    }
    
    @MainActor
    func modifyRole(idRol: String, idUsuario: String) async {
        let response = await modificarRolRequirement.modifyRole(idRol: idRol, idUsuario: idUsuario)
    }
    
}
