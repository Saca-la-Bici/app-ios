//
//  EventosViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import SwiftUI

@MainActor
class EventosViewModel: ObservableObject {
    @Published var eventos: [Evento] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getEventosUseCase: GetEventosUseCase
    private var userSessionManager = UserSessionManager.shared
    
    init(getEventosUseCase: GetEventosUseCase = GetEventosUseCase(repository: ActividadesRepository())) {
        self.getEventosUseCase = getEventosUseCase
        fetchEventos()
    }
    
    func fetchEventos() {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                let (eventos, permisos) = try await getEventosUseCase.execute()
                self.eventos = eventos
                userSessionManager.updatePermisos(newPermisos: permisos)
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
                print("Error al obtener eventos: \(error)")
            }
        }
    }
    
}
