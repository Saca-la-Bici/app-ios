//
//  ContentView.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 03/10/24.
//


import SwiftUI

struct ContentView: View {
    @State private var startPoint: CoordenadasBase? = nil
    @State private var stopoverPoint: CoordenadasBase? = nil
    @State private var endPoint: CoordenadasBase? = nil

    var body: some View {
        TabView {
            RegisterRouteView(
                startPoint: $startPoint,
                stopoverPoint: $stopoverPoint,
                endPoint: $endPoint
            )
            .tabItem {
                Label("Registrar Ruta", systemImage: "plus")
            }
            
            RoutesListView()
                .tabItem {
                    Label("Rutas", systemImage: "list.bullet")
                }
        }
    }
}

