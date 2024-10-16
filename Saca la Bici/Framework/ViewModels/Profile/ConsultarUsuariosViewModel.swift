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
    @Published var isLoadingMore: Bool = false
    @Published var hasMoreData: Bool = true
    @Published var totalUsuarios: Int = 0

    private let getUsuariosUseCase: GetUsuariosUseCase
    private let modificarRolRequirement: ModificarRolRequirement
    private var currentPage: Int = 1
    private let limit: Int = 10
    
    enum ActiveAlert: Identifiable {
        case error
        case success
        case errorConsultar

        var id: Int {
            hashValue
        }
    }
    
    @Published var activeAlert: ActiveAlert?
    @Published var alertMessage: String?

    init(getUsuariosUseCase: GetUsuariosUseCase = GetUsuariosUseCase(), modificarRolRequirement: ModificarRolRequirement = ModificarRolRequirement.shared) {
        self.getUsuariosUseCase = getUsuariosUseCase
        self.modificarRolRequirement = modificarRolRequirement
    }
    
    @MainActor
    func cargarUsuarios(roles: [String]) {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        Task {
            do {
                let response = try await getUsuariosUseCase.execute(page: currentPage, limit: limit, roles: roles)
                
                if response.message == "No se encontraron usuarios." {
                    isLoading = false
                    isLoadingMore = false
                    return
                } else {
                    usuarios.append(contentsOf: response.usuarios ?? [])
                    totalUsuarios = response.totalUsuarios ?? 0
                    currentPage += 1
                }
            } catch {
                activeAlert = .errorConsultar
                alertMessage = "Hubo un error al cargar los usuarios. Por favor intenta de nuevo."
            }
            isLoading = false
            isLoadingMore = false
        }
    }
    
    @MainActor
    func buscadorUsuarios(roles: [String], search: String) {
        Task {
            do {
                if usuarios.count < totalUsuarios {
                    let response = try await getUsuariosUseCase.buscadorUsuarios(
                        page: currentPage, limit: limit, roles: roles, search: search)

                    if response.usuarios == [] {
                        // Si está vacío, se regresa ya que no hay nada
                        isLoading = false
                        return
                    }
                    
                    usuarios.append(contentsOf: response.usuarios ?? [])
                    totalUsuarios = response.totalUsuarios ?? 0
                    currentPage += 1
                } else {
                    hasMoreData = false
                }
            } catch {
                activeAlert = .errorConsultar
                alertMessage = "Hubo un error al cargar los usuarios. Por favor intenta de nuevo."
            }
            isLoading = false
        }

    }

    @MainActor
    func resetPagination() {
        currentPage = 1
        usuarios = []
        hasMoreData = true
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
        
        if response == 200 {
            self.activeAlert = .success
            self.alertMessage = "¡El rol del usuario ha sido modificado!"
        } else {
            self.activeAlert = .error
            self.alertMessage = "Hubo un error al actualizar el rol del usuario. Favor de intentar de nuevo."
        }
    }
    
}
