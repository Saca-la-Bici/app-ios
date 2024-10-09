//
//  ModificarRolRequirement.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 07/10/24.
//

import Foundation

// Creas el protocolo de la historia de usuario
protocol ModificarRolRequirementProtocol {
    func modifyRole(idRol: String, idUsuario: String) async -> Int?
}

class ModificarRolRequirement: ModificarRolRequirementProtocol {

    // Singleton para que lo use el Requirement
    static let shared = ModificarRolRequirement()

    private let usuariosRepository: UsuariosRepository

    init(usuariosRepository: UsuariosRepository = UsuariosRepository()) {
        self.usuariosRepository = usuariosRepository
    }
    
    func modifyRole(idRol: String, idUsuario: String) async -> Int? {
        return await usuariosRepository.modifyRole(idRol: idRol, idUsuario: idUsuario)
    }
}
