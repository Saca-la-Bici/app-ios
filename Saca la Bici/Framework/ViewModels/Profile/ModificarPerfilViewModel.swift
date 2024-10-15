//
//  ModificarPerfilViewModel.swift
//  Saca la Bici
//
//  Created by Diego Lira on 14/10/24.
//

import Foundation

class ModificarPerfilViewModel: ObservableObject {
    
    let modificarPerfilRequirement = ModificarPerfilRequirement()
    
    private var resultado: String = ""
    
    @MainActor
    func modificarPerfil(nombre: String, username: String, tipoSangre: String, numeroEmergencia: String) async -> String {
        
        do {
            resultado = try await modificarPerfilRequirement.modificarPerfil(
                nombre: nombre, username: username,
                tipoSangre: tipoSangre, numeroEmergencia: numeroEmergencia)
        } catch {
            print("Error: \(error.localizedDescription)")
            resultado = "Error al modificar el perfil, intentelo más tarde"
        }
        
        return resultado
    }
    
}
