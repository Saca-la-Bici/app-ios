//
//  Actividadesrepository.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import Foundation

protocol ActividadesAPIProtocol {
    func getRodadas() async throws -> (rodadas: [Rodada], permisos: [String])
    func getEventos() async throws -> (eventos: [Evento], permisos: [String])
    func getTalleres() async throws -> (talleres: [Taller], permisos: [String])
    func registrarActividad(actividad: DatosActividad) async throws -> Int?
    func consultarActividadIndividual(actividadID: String) async -> ActividadIndividualResponse?
    func verificarAsistencia(IDRodada: String, codigo: String) async -> AsistenciaResponse?
}

class ActividadesRepository: ActividadesAPIProtocol {

    static let shared = ActividadesRepository()
    
    let actividadesAPIService: ActividadesAPIService

    init(actividadesAPIService: ActividadesAPIService = ActividadesAPIService.shared) {
        self.actividadesAPIService = actividadesAPIService
    }

    func getRodadas() async throws -> (rodadas: [Rodada], permisos: [String]) {
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)\(Api.Routes.consultar)\(Api.Routes.rodadas)") else {
            throw URLError(.badURL)
        }

        do {
            let response = try await actividadesAPIService.fetchRodadas(url: url)
            
            let rodadas = response.rodadas.flatMap { response in
                response.informacion.map { actividad in
                    Rodada(id: response._id, actividad: actividad, ruta: response.ruta)
                }
            }
            
            return (rodadas, response.permisos)  
        } catch {
            print("Error en ActividadesRepository.getRodadas: \(error)")
            throw error
        }
    }
    
    func getEventos() async throws -> (eventos: [Evento], permisos: [String]) {
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)\(Api.Routes.consultar)\(Api.Routes.eventos)") else {
            throw URLError(.badURL)
        }

        do {
            let response = try await actividadesAPIService.fetchEventos(url: url)
            
            let eventos = response.eventos.flatMap { response in
                response.informacion.map { actividad in
                    Evento(id: response._id, actividad: actividad)
                }
            }
            
            return (eventos, response.permisos)
        } catch {
            print("Error en ActividadesRepository.getEventos: \(error)")
            throw error
        }
    }
    
    func getTalleres() async throws -> (talleres: [Taller], permisos: [String]) {
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)\(Api.Routes.consultar)\(Api.Routes.talleres)") else {
            throw URLError(.badURL)
        }
        
        do {
            let response = try await actividadesAPIService.fetchTalleres(url: url)
            
            let talleres = response.talleres.flatMap { response in
                response.informacion.map { actividad in
                    Taller(id: response._id, actividad: actividad)
                }
            }
            
            return (talleres, response.permisos)
        } catch {
            print("Error en ActividadesRepository.getTalleres: \(error)")
            throw error
        }
    }
    
    func registrarActividad(actividad: DatosActividad) async throws -> Int? {
        let tipo = actividad.tipo

        var terminacionURL: String = ""

        if tipo == "Taller" {
            terminacionURL = "/taller"
        } else if tipo == "Rodada" {
            terminacionURL = "/rodada"
        } else if tipo == "Evento" {
            terminacionURL = "/evento"
        }
        return try await actividadesAPIService.registrarActividad(
            url: URL(string: "\(Api.base)\(Api.Routes.actividades)/registrar\(terminacionURL)")!, actividad: actividad)
    }
    
    func consultarActividadIndividual(actividadID: String) async -> ActividadIndividualResponse? {
        return await actividadesAPIService.consultarActividadIndividual(
            url: URL(string: "\(Api.base)\(Api.Routes.actividades)/consultar")!, actividadID: actividadID)
    }
    
    func inscribirActividad(actividadId: String, tipo: String) async throws -> ActionResponse {
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)/inscripcion/inscribir") else {
            throw URLError(.badURL)
        }

        return try await actividadesAPIService.inscribirActividad(url: url, actividadId: actividadId, tipo: tipo)
    }

    func cancelarAsistencia(actividadId: String, tipo: String) async throws -> ActionResponse {
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)/cancelarAsistencia/cancelar") else {
            throw URLError(.badURL)
        }

        return try await actividadesAPIService.cancelarAsistencia(url: url, actividadId: actividadId, tipo: tipo)
    }
    
    func verificarAsistencia(IDRodada: String, codigo: String) async -> AsistenciaResponse? {
        return await actividadesAPIService.verificarAsistencia(
            url: URL(string: "\(Api.base)\(Api.Routes.rodadas)/verificarAsistencia")!, IDRodada: IDRodada, codigo: codigo)
    }
    
    func modificarActividad(id: String, datosActividad: ModificarActividadModel) async throws -> ActionResponse? {
        
        var tipoURL = "/"
        
        switch datosActividad.tipo {
        case "Rodada":
            tipoURL += "rodada"
        case "Evento":
            tipoURL += "evento"
        case "Taller":
            tipoURL += "taller"
        default:
            tipoURL += ""
        }
        
        guard let url = URL(string: "\(Api.base)\(Api.Routes.actividades)/modificar\(tipoURL)?id=\(id)") else {
            throw URLError(.badURL)
        }
        
        print("URL: \(url)")
        
        return try await actividadesAPIService.modificarActividad(url: url, id: id, datosActividad: datosActividad)
    }
    
    func eliminarActividad(id: String, tipo: String) async throws -> EliminarActividadResponse {
        let url = URL(string: "\(Api.base)\(Api.Routes.actividades)/eliminar")!
        return try await actividadesAPIService.eliminarActividad(url: url, id: id, tipo: tipo)
    }
}
