//
//  ConsultarAnuncioRequirement.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 17/09/24.
//

import Foundation

struct AnuncioRequirement {
    static func esValido(anuncio: Anuncio) -> Bool {
        return !anuncio.titulo.isEmpty && !anuncio.contenido.isEmpty
    }
}
