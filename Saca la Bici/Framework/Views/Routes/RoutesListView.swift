//
//  RoutesListView.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 25/09/24.
//

import SwiftUI

struct RoutesListView: View {
    @State private var rutas: [RutasBase] = []

    var body: some View {
        NavigationView {
            List(rutas) { ruta in
                NavigationLink(destination: DetalleRutaView(ruta: ruta)) {
                    VStack(alignment: .leading) {
                        Text(ruta.titulo).font(.headline)
                        Text("Distancia: \(ruta.distancia)")
                        Text("Tiempo: \(ruta.tiempo)")
                        Text("Nivel: \(ruta.nivel)")
                    }
                }
            }
            .navigationBarTitle("Mis Rutas")
            .onAppear(perform: fetchRutas)
        }
    }

    private func fetchRutas() {
        RutasService.shared.getRutasList { rutasFetched in
            DispatchQueue.main.async {
                if let rutasFetched = rutasFetched {
                    self.rutas = rutasFetched
                } else {
                    print("No se obtuvieron rutas.")
                }
            }
        }
    }
}


