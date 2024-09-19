//
//  APIRoutes.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import Foundation

struct Api {
    // Esta es la base del URL (se usa en TODAS las llamadas)
    static let base = "http://3.145.117.182:8080"
    
    // Es las rutas del API, donde /pokemon es como un modulo. Puede haber más
    struct routes {
        static let session = "/session"
        static let status = "/status"
        static let consultarAnuncio = "/anuncios/consultar"
    }
}
