//
//  Actividades.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 26/09/24.
//

import Foundation

struct RodadasApiResponse: Codable {
    let rodadas: [RodadasResponse]
    let permisos: [String]
}

struct EventosApiResponse: Codable {
    let eventos: [EventosResponse]
    let permisos: [String]
}

struct TalleresApiResponse: Codable {
    let talleres: [TalleresResponse]
    let permisos: [String]
}

struct RodadasResponse: Codable {
    let _id: String
    let informacion: [Actividad]
    let ruta: Ruta
}

struct EventosResponse: Codable {
    let _id: String
    let informacion: [Actividad]
}

struct TalleresResponse: Codable {
    let _id: String
    let informacion: [Actividad]
}

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

struct Actividad: Codable, Identifiable {
    let _id: String
    let titulo: String
    let fecha: String
    let hora: String
    let personasInscritas: Int
    let ubicacion: String
    let descripcion: String
    let estado: Bool
    let duracion: String
    let imagen: String?
    let tipo: String
    let comentarios: String?
    let usuariosInscritos: [String]

    var id: String { _id }
}

struct DatosActividad: Codable {
    let titulo: String
    let fecha: String
    let hora: String
    let duracion: String
    let descripcion: String
    let imagen: Data?
    let tipo: String
    let ubicacion: String
    let ruta: String?
}

struct ActividadIndividualResponse: Codable {
    let actividad: ActividadResponse
    let permisos: [String]
    
    init(actividad: ActividadResponse = ActividadResponse(), permisos: [String] = []) {
        self.actividad = actividad
        self.permisos = permisos
    }
}

struct ActividadResponse: Codable {
    let _id: String
    let informacion: [Actividad]
    let ruta: Ruta?
    let codigoAsistencia: Int?
    let usuariosVerificados: [String]?
    
    init(_id: String = "", informacion: [Actividad] = [], ruta: Ruta? = nil,
         codigoAsistencia: Int? = nil, usuariosVerificados: [String]? = []) {
        self._id = _id
        self.informacion = informacion
        self.ruta = ruta
        self.codigoAsistencia = codigoAsistencia
        self.usuariosVerificados = usuariosVerificados
    }
}

struct ActionResponse: Codable {
    let message: String
}

struct AsistenciaResponse: Codable {
    let status: Int
    let message: String
    let nuevaMedallaGanada: Bool?
}
