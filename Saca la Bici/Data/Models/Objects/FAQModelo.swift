//
//  FAQModelo.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import Foundation

struct FAQResponse : Codable {
    var code: Int
    var msg: String
    var permisos: [String]
    var data: [FAQ]
}

struct FAQ : Codable, Hashable, Identifiable {
    var id: Int { IdPregunta }
    var IdPregunta: Int
    var Pregunta: String
    var Respuesta: String
    var Tema: String
    var Imagen: String
}

struct TemaFAQ : Identifiable {
    var id = UUID() // ID para el protocolo Identifiable
    var tema: String
    var faqs: [FAQ]
}
