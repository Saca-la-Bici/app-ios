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
    case faqs
    case faqDetail (faq: FAQ, permisos: [String])
    case addFAQ
    case updateFAQ (faq: FAQ)
    case decalogo
}
