//
//  EventosViewModel.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import SwiftUI
import FirebaseAuth

@MainActor
class EventosViewModel: ObservableObject {
    @Published var eventos: [Evento] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let currentUserId = Auth.auth().currentUser?.uid
    
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
    
    func fetchEventosFiltrados() {
        Task {
            do {
                isLoading = true
                errorMessage = nil
                let (eventos, permisos) = try await getEventosUseCase.execute()
                userSessionManager.updatePermisos(newPermisos: permisos)
                
                // Obtener el UID del usuario actual
                guard let currentUserId = Auth.auth().currentUser?.uid else {
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se pudo obtener el ID del usuario actual"])
                }
                
                // Filtrar los eventos donde usuariosInscritos contiene el UID del usuario actual
                let eventosFiltrados = eventos.filter { evento in
                    evento.actividad.usuariosInscritos.contains(currentUserId)
                }
                
                // Asignar los eventos filtrados a self.eventos
                self.eventos = eventosFiltrados
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
                print("Error al obtener eventos: \(error)")
            }
        }
    }
    
}
