//
//  RutasRepository.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 15/10/24.
//

import Foundation

protocol RutasAPIProtocol {
    func getRutas() async -> RutasResponse?
}

class RutasRepository: RutasAPIProtocol {

    static let shared = RutasRepository()
    
    let rutasAPIService: RutasAPIService

    init(rutasAPIService: RutasAPIService = RutasAPIService.shared) {
        self.rutasAPIService = rutasAPIService
    }
    
    func getRutas() async -> RutasResponse? {
        return await rutasAPIService.getRutas(
            url: URL(string: "\(Api.base)\(Api.Routes.mapa)/consultarRutas")!)
    }
}
