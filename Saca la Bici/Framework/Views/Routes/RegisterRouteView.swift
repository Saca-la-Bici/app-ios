//
//  RegisterRouteView.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 25/09/24.
//

import SwiftUI

struct RegisterRouteView: View {
    @Binding var startPoint: CoordenadasBase?
    @Binding var stopoverPoint: CoordenadasBase?
    @Binding var endPoint: CoordenadasBase?

    @State private var titulo: String = ""
    @State private var tiempo: String = ""
    @State private var nivel: String = "Principiante"
    @State private var showConfirmation = false
    @State private var errorMessage: String? = nil
    @State private var isSelectingStartPoint = false
    @State private var isSelectingStopoverPoint = false
    @State private var isSelectingEndPoint = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Puntos de la Ruta")) {
                    Button(action: { isSelectingStartPoint.toggle() }) {
                        Text(startPoint != nil ? "Punto de inicio: \(startPoint!.latitud), \(startPoint!.longitud)" : "Selecciona el punto de inicio en el mapa")
                    }
                    
                    Button(action: { isSelectingStopoverPoint.toggle() }) {
                        Text(stopoverPoint != nil ? "Punto de descanso: \(stopoverPoint!.latitud), \(stopoverPoint!.longitud)" : "Selecciona el punto de descanso en el mapa")
                    }
                    
                    Button(action: { isSelectingEndPoint.toggle() }) {
                        Text(endPoint != nil ? "Punto final: \(endPoint!.latitud), \(endPoint!.longitud)" : "Selecciona el punto final en el mapa")
                    }
                }

                TextField("Título", text: $titulo)
                TextField("Tiempo estimado", text: $tiempo)
                Picker("Nivel", selection: $nivel) {
                    Text("Principiante").tag("Principiante")
                    Text("Intermedio").tag("Intermedio")
                    Text("Experto").tag("Experto")
                }
                .pickerStyle(SegmentedPickerStyle())

                Button(action: {
                    guardarRuta()
                }) {
                    Text("Guardar Ruta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .sheet(isPresented: $isSelectingStartPoint) {
            RegisterRouteMapView(mapView: .constant(nil), startPoint: $startPoint, stopoverPoint: .constant(nil), endPoint: .constant(nil))
        }
        .sheet(isPresented: $isSelectingStopoverPoint) {
            RegisterRouteMapView(mapView: .constant(nil), startPoint: .constant(nil), stopoverPoint: $stopoverPoint, endPoint: .constant(nil))
        }
        .sheet(isPresented: $isSelectingEndPoint) {
            RegisterRouteMapView(mapView: .constant(nil), startPoint: .constant(nil), stopoverPoint: .constant(nil), endPoint: $endPoint)
        }
    }

    private func guardarRuta() {
        guard let startPoint = startPoint, let stopoverPoint = stopoverPoint, let endPoint = endPoint else {
            errorMessage = "Por favor selecciona todos los puntos de la ruta"
            return
        }

        RutasService.shared.sendRoute(
            titulo: titulo,
            distancia: "Por calcular",
            tiempo: tiempo,
            nivel: nivel,
            start: startPoint,
            stopover: stopoverPoint,
            end: endPoint
        ) { success in
            DispatchQueue.main.async {
                if success {
                    showConfirmation = true
                } else {
                    errorMessage = "Error al guardar la ruta"
                }
            }
        }
    }
}
