//
//  ActivitiesPaths.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 30/09/24.
//

import Foundation

enum ActivitiesPaths: Hashable {
    case evento
    case rodada
    case taller
    case descripcionRodada
    case descripcionEvento
    case descripcionTaller
    case rutas
    case detalle(id: String)
    case editarRodada(id: String)
    case editarEvento(id: String)
    case editarTaller(id: String)
    case editarDescripcionRodada(id: String)
    case editarDescripcionEvento(id: String)
    case editarDescripcionTaller(id: String)
}
