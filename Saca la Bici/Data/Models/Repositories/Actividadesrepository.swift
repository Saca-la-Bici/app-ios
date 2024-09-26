//
//  Actividadesrepository.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import Foundation

struct Rodada: Identifiable {
    let id: String
    let actividad: Actividad
    let ruta: Ruta
}

class ActividadesRepository {

    private let apiService: APIService

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func getRodadas() async throws -> [Rodada] {
        // Construir la URL aquí
        guard let url = URL(string: "\(Api.baseURL)\(Api.Routes.actividades)\(Api.Routes.consultar)\(Api.Routes.rodadas)") else {
            throw URLError(.badURL)
        }

        do {
            let rodadasResponses = try await apiService.fetchRodadas(url: url)

            let rodadas = rodadasResponses.flatMap { response in
                response.informacion.map { actividad in
                    Rodada(id: actividad._id, actividad: actividad, ruta: response.ruta)
                }
            }
            return rodadas
        } catch {
            print("Error en ActividadesRepository.getRodadas: \(error)")
            throw error
        }
    }
}
