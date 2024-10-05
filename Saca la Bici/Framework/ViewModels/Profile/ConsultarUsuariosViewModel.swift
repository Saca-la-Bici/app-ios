//
//  ConsultarUsuariosViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import SwiftUI
import Foundation
import Alamofire

@MainActor
class ConsultarUsuariosViewModel: ObservableObject {
    @Published var usuarios: [ConsultarUsuario] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasMoreUsers: Bool = true

    private let getUsuariosUseCase: GetUsuariosUseCase
    private var currentPage: Int = 1
    private let limit: Int = 10

    init(getUsuariosUseCase: GetUsuariosUseCase = GetUsuariosUseCase()) {
        self.getUsuariosUseCase = getUsuariosUseCase
    }

    func cargarUsuarios(roles: [String]) {
        guard !isLoading && hasMoreUsers else { return }
        isLoading = true
        Task {
            do {
                let nuevosUsuarios = try await getUsuariosUseCase.execute(page: currentPage, limit: limit, roles: roles)
                if nuevosUsuarios.isEmpty {
                    hasMoreUsers = false
                } else {
                    usuarios.append(contentsOf: nuevosUsuarios)
                    currentPage += 1
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func resetPagination() {
        currentPage = 1
        usuarios = []
        hasMoreUsers = true
    }
}
