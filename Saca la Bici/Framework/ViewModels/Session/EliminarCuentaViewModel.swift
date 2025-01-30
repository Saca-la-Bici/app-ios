//
//  EliminarCuentaViewModel.swift
//  Saca la Bici
//
//  Created by Diego Lira on 28/01/25.
//

import Foundation
import FirebaseAuth

class EliminarCuentaViewModel: ObservableObject {
    private let eliminarCuentaRequirement = EliminarCuentaRequirement()
    
    @Published var passwordUser: Bool = false
    @Published var googleUser: Bool = false
    @Published var appleUser: Bool = false
    
    @MainActor
    func eliminarCuenta() async -> String {
        do {
            // Llamamos a la lógica de eliminación en la capa Requirements
            let exito = try await eliminarCuentaRequirement.eliminarCuenta()

            // Aquí decidimos qué mensaje mostrar con base en el resultado
            if exito {
                return "¡Listo! Tu cuenta y datos han sido borrados. Lamentamos verte partir."
            } else {
                return "No se pudo eliminar tu cuenta. Intenta de nuevo más tarde o revisa tu conexión."
            }
        } catch {
            // En caso de error inesperado
            return "Ocurrió un error inesperado. Por favor, intenta de nuevo."
        }
    }
    
    func checarProveedores() {
        for proveedor in Auth.auth().currentUser?.providerData ?? [] {
            if proveedor.providerID == "password" {
                self.passwordUser = true
            }
            if proveedor.providerID == "google.com" {
                self.googleUser = true
            }
            if proveedor.providerID == "apple.com" {
                self.appleUser = true
            }
        }
    }
}
