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
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()

        // Coordenadas de Querétaro
        let queretaroCoordinates = CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899)
        let cameraOptions = CameraOptions(center: queretaroCoordinates, zoom: 12)

        let mapView = MapView(frame: .zero)
        mapView.mapboxMap.setCamera(to: cameraOptions)

        // Objeto puck para mostrar la ubicación del usuario
        var locationOptions = LocationOptions()
        locationOptions.puckType = .puck2D()
        mapView.location.options = locationOptions

        // Seguimiento la ubicación del usuario
        let followPuckViewportState = mapView.viewport.makeFollowPuckViewportState()
        mapView.viewport.transition(to: followPuckViewportState)

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
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

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.accuracyAuthorization == .reducedAccuracy {
                print("El usuario ha seleccionado precisión reducida")
                manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "LocationAccuracyAuthorizationDescription")
            } else {
                print("Precisión completa activada")
            }
        }

        // Actualizaciones de la ubicación del usuario
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            print("Ubicación actualizada: \(location.coordinate)")
        }
    }
}
