//
//  ContentView.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 09/10/24.
//

import SwiftUI
import MapboxMaps

struct ContentView: View {
    var body: some View {
        MapViewContainer()
            .ignoresSafeArea()
    }
}

struct MapViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> MapView {
        // Coordenadas de Querétaro y posición de camara
        let queretaroCoordinates = CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899)
        let cameraOptions = CameraOptions(center: queretaroCoordinates, zoom: 12)
        
        let mapView = MapView(frame: .zero)
        
        mapView.mapboxMap.setCamera(to: cameraOptions)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        // Actualizaciones de la vista (por el momento es opcional)
    }
}
