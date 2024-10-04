//
//  RegisterRouteMapView.swift
//  Saca la Bici
//
//  Created by Arturo Sanchez on 25/09/24.
//

// RegisterRouteMapView.swift
import SwiftUI
import MapboxMaps

struct RegisterRouteMapView: UIViewRepresentable {
    @Binding var mapView: MapView?
    @Binding var startPoint: CoordenadasBase?
    @Binding var stopoverPoint: CoordenadasBase?
    @Binding var endPoint: CoordenadasBase?
    
    func makeUIView(context: Context) -> MapView {
        let mapInitOptions = MapInitOptions(
            cameraOptions: CameraOptions(center: CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899), zoom: 12.0)
        )
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)
        self.mapView = mapView
        setupMap(mapView: mapView, context: context) // Pasamos el contexto aquí
        return mapView
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {}
    
    private func setupMap(mapView: MapView, context: Context) {
        mapView.mapboxMap.setCamera(to: CameraOptions(zoom: 12.0))
        
        // Añadir un gesto de clic largo para seleccionar los puntos
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    // Coordinador para manejar los gestos
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: RegisterRouteMapView
        
        init(_ parent: RegisterRouteMapView) {
            self.parent = parent
        }
        
        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            guard let mapView = parent.mapView else { return }
            
            let point = gesture.location(in: mapView)
            let coordinate = mapView.mapboxMap.coordinate(for: point)
            
            if gesture.state == .began {
                if parent.startPoint?.latitud == nil {  // Si aún no se ha seleccionado el punto de inicio
                    parent.startPoint = CoordenadasBase(id: UUID().uuidString, latitud: coordinate.latitude, longitud: coordinate.longitude, tipo: "inicio")
                    print("Punto de inicio establecido")
                } else if parent.stopoverPoint?.latitud == nil {  // Si aún no se ha seleccionado el punto de descanso
                    parent.stopoverPoint = CoordenadasBase(id: UUID().uuidString, latitud: coordinate.latitude, longitud: coordinate.longitude, tipo: "descanso")
                    print("Punto de descanso establecido")
                } else if parent.endPoint?.latitud == nil {  // Si aún no se ha seleccionado el punto final
                    parent.endPoint = CoordenadasBase(id: UUID().uuidString, latitud: coordinate.latitude, longitud: coordinate.longitude, tipo: "final")
                    print("Punto final establecido")
                } else {
                    print("Ya se han seleccionado todos los puntos.")
                }
            }
        }
    }
}
