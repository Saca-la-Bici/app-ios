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

struct Evento: Identifiable {
    let id: String
    let actividad: Actividad
}

struct Taller: Identifiable {
    let id: String
    let actividad: Actividad
}

class ActividadesRepository {

    private let apiService: APIService

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }

    func getRodadas() async throws -> [Rodada] {
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)\(Api.Routes.consultar)\(Api.Routes.rodadas)") else {
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
    
    func getEventos() async throws -> [Evento] {
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)\(Api.Routes.consultar)\(Api.Routes.eventos)") else {
            throw URLError(.badURL)
        }

        do {
            let eventosResponses = try await apiService.fetchEventos(url: url)

            let eventos = eventosResponses.flatMap { response in
                response.informacion.map { actividad in
                    Evento(id: actividad._id, actividad: actividad)
                }
            }
            return eventos
        } catch {
            print("Error en ActividadesRepository.getEventos: \(error)")
            throw error
        }
    }
    
    func getTalleres() async throws -> [Taller] {
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)\(Api.Routes.consultar)\(Api.Routes.talleres)") else {
            throw URLError(.badURL)
        }
        
        do {
            let talleresResponses = try await apiService.fetchTalleres(url: url)

            let talleres = talleresResponses.flatMap { response in
                response.informacion.map { actividad in
                    Taller(id: actividad._id, actividad: actividad)
                }
            }
            return talleres
        } catch {
            print("Error en ActividadesRepository.getTalleres: \(error)")
            throw error
        }
    }
}
