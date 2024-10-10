//
//  ContentView.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 09/10/24.
//

import SwiftUI
import MapboxMaps
import CoreLocation

struct ContentView: View {
    var body: some View {
        MapViewContainer()
            .ignoresSafeArea()
    }
}

struct MapViewContainer: UIViewRepresentable {
    let locationManager = CLLocationManager()

    func makeUIView(context: Context) -> MapView {
        // Inicializa el CLLocationManager para manejar los permisos de localización
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()

        // Coordenadas de Querétaro y configuración inicial de la cámara
        let queretaroCoordinates = CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899)
        let cameraOptions = CameraOptions(center: queretaroCoordinates, zoom: 12)

        // Inicializa el MapView
        let mapView = MapView(frame: .zero)
        mapView.mapboxMap.setCamera(to: cameraOptions)

        // Habilitar la "puck" para mostrar la ubicación del usuario
        var locationOptions = LocationOptions()
        locationOptions.puckType = .puck2D()
        mapView.location.options = locationOptions

        // Hacer que la cámara siga la ubicación del usuario
        let followPuckViewportState = mapView.viewport.makeFollowPuckViewportState()
        mapView.viewport.transition(to: followPuckViewportState)

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Aquí puedes manejar actualizaciones del mapa si es necesario
    }

    // Coordinator para manejar las delegaciones de CLLocationManager
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapViewContainer

        init(_ parent: MapViewContainer) {
            self.parent = parent
        }

        // Manejo de cambios en el estado de los permisos de localización
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Permisos de localización concedidos")
                manager.startUpdatingLocation()
            case .denied, .restricted:
                print("Permisos de localización denegados")
            case .notDetermined:
                print("Permisos de localización no determinados")
            @unknown default:
                print("Estado desconocido")
            }
        }

        // Manejo de actualizaciones de la ubicación del usuario
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            print("Ubicación actualizada: \(location.coordinate)")
        }
    }
}
