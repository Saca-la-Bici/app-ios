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
    private var userSessionManager = UserSessionManager.shared
    
    init(getRodadasUseCase: GetRodadasUseCase = GetRodadasUseCase(repository: ActividadesRepository())) {
        self.getRodadasUseCase = getRodadasUseCase
    }
    
    func fetchRodadas() {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                let (rodadas, permisos) = try await getRodadasUseCase.execute()
                self.rodadas = rodadas
                userSessionManager.updatePermisos(newPermisos: permisos)
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
                print("Error al obtener rodadas: \(error)")
            }
        }
    }
}
