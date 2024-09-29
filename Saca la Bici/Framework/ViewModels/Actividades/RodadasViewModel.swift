//
//  ActividadesViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import SwiftUI

@MainActor
class RodadasViewModel: ObservableObject {
    @Published var rodadas: [Rodada] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getRodadasUseCase: GetRodadasUseCase
    private var sessionManager = UserSessionManager.shared
    
    init(getRodadasUseCase: GetRodadasUseCase = GetRodadasUseCase(repository: ActividadesRepository())) {
        self.getRodadasUseCase = getRodadasUseCase
        fetchRodadas()
    }
    
    func fetchRodadas() {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                let (rodadas, rol) = try await getRodadasUseCase.execute()
                self.rodadas = rodadas
                sessionManager.updateRol(newRol: rol)
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
                print("Error al obtener rodadas: \(error)")
            }
        }
    }
    
    func isUserAdmin() -> Bool {
        return sessionManager.isAdmin()
    }
    
    func isUserStaff() -> Bool {
        return sessionManager.isStaff()
    }
    
    func isUser() -> Bool {
        return sessionManager.isUser()
    }
}
