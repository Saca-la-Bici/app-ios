//
//  EliminarCuentaViewModel.swift
//  Saca la Bici
//
//  Created by Diego Lira on 28/01/25.
//

import Foundation

class EliminarCuentaViewModel: ObservableObject {
    private let eliminarCuentaRequirement = EliminarCuentaRequirement()

    func eliminarCuenta() async -> String {
        do {
            // Llamamos a la lógica de eliminación en la capa Requirements
            let exito = try await eliminarCuentaRequirement.eliminarCuenta()

            // Aquí decidimos qué mensaje mostrar con base en el resultado
            if exito {
                return "Cuenta eliminada correctamente."
            } else {
                return "No se pudo eliminar tu cuenta. Intenta de nuevo más tarde o revisa tu conexión."
            }
        } catch {
            // En caso de error inesperado
            return "Ocurrió un error inesperado. Por favor, intenta de nuevo."
        }
    }
}
