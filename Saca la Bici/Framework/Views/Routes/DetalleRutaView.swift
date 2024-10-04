//
//  DetalleRutaView.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 03/10/24.
//

import SwiftUI

struct DetalleRutaView: View {
    let ruta: RutasBase

    var body: some View {
        VStack {
            Text(ruta.titulo).font(.largeTitle)
            Text("Distancia: \(ruta.distancia)")
            Text("Tiempo: \(ruta.tiempo)")
            Text("Nivel: \(ruta.nivel)")
        }
        .navigationBarTitle("Detalle de la Ruta", displayMode: .inline)
    }
}
