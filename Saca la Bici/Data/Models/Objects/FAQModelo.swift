//
//  FAQModelo.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Foundation

struct FAQResponse : Codable {
    var faqs: [FAQ]
    var rol: String
}

struct FAQ : Codable, Hashable, Identifiable {
    var id = UUID() // ID para el protocolo Identifiable
    var idPregunta: Int
    var pregunta: String
    var respuesta: String
    var tema: String
    var imagen: String
}

struct TemaFAQ : Identifiable {
    var id = UUID()
    var tema: String
    var faqs: [FAQ]
}
