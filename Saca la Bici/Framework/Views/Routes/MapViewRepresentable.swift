//
//  MapViewRepresentable.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 25/09/24.
//


import SwiftUI
import MapboxMaps

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var mapView: MapView?

    func makeUIView(context: Context) -> MapView {
        let mapInitOptions = MapInitOptions(
            cameraOptions: CameraOptions(center: CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899), zoom: 12.0)
        )
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)
        self.mapView = mapView
        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {}
}
