//
//  TalleresViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import SwiftUI

@MainActor
class TalleresViewModel: ObservableObject {
    @Published var talleres: [Taller] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getTalleresUseCase: GetTalleresUseCase
    private var userSessionManager = UserSessionManager.shared
    
    init(getTalleresUseCase: GetTalleresUseCase = GetTalleresUseCase(repository: ActividadesRepository())) {
        self.getTalleresUseCase = getTalleresUseCase
    }
    
    func fetchTalleres() {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                let (talleres, permisos) = try await getTalleresUseCase.execute()
                self.talleres = talleres
                userSessionManager.updatePermisos(newPermisos: permisos)
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
                print("Error al obtener talleres: \(error)")
            }
        }
    }
}
