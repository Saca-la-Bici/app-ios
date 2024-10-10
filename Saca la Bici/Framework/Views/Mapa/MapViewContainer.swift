import SwiftUI
import MapboxMaps
import CoreLocation

struct MapViewContainer: UIViewRepresentable {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    let locationManager = CLLocationManager()
    
    // Puntos de interés (inicio, descanso y fin)
    enum RoutePointType: String {
        case start = "Inicio"
        case rest = "Descanso"
        case end = "Fin"
    }
    
    // Contador para los tres puntos
    @State private var pointTypes: [RoutePointType] = [.start, .rest, .end]
    
    func makeUIView(context: Context) -> MapView {
        let mapView = MapView(frame: .zero)
        
        // Inicializa la cámara en Querétaro
        let queretaroCoordinates = CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899)
        let cameraOptions = CameraOptions(center: queretaroCoordinates, zoom: 14)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        
        // Configura el locationManager para pedir permisos de ubicación
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Mostrar la ubicación del usuario con un puck
        var locationOptions = LocationOptions()
        locationOptions.puckType = .puck2D()
        mapView.location.options = locationOptions
        
        // Manejadores de anotaciones
        let pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        let polylineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
        
        // Detectar taps en el mapa
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        context.coordinator.mapView = mapView
        context.coordinator.pointAnnotationManager = pointAnnotationManager
        context.coordinator.polylineAnnotationManager = polylineAnnotationManager
        
        return mapView
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        context.coordinator.updateAnnotations(routeCoordinates: routeCoordinates)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, routeCoordinates: $routeCoordinates, distance: $distance)
    }

    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapViewContainer
        var routeCoordinates: Binding<[CLLocationCoordinate2D]>
        var distance: Binding<Double>
        var mapView: MapView?
        var pointAnnotationManager: PointAnnotationManager?
        var polylineAnnotationManager: PolylineAnnotationManager?
        
        var pointTypes: [RoutePointType] = [.start, .rest, .end]

        init(_ parent: MapViewContainer, routeCoordinates: Binding<[CLLocationCoordinate2D]>, distance: Binding<Double>) {
            self.parent = parent
            self.routeCoordinates = routeCoordinates
            self.distance = distance
        }

        // Maneja los taps en el mapa para agregar puntos
        @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
            guard let mapView = mapView else { return }
            let location = sender.location(in: mapView)
            let coordinate = mapView.mapboxMap.coordinate(for: location)
            
            // Limitar a tres puntos
            if routeCoordinates.wrappedValue.count < 3 {
                routeCoordinates.wrappedValue.append(coordinate)
                updateAnnotations(routeCoordinates: routeCoordinates.wrappedValue)
                calculateDistance()
            } else {
                print("Solo se permiten tres puntos: inicio, descanso y fin.")
            }
        }

        // Actualiza las anotaciones en el mapa
        func updateAnnotations(routeCoordinates: [CLLocationCoordinate2D]) {
            guard routeCoordinates.count <= 3 else { return }
            
            let pointAnnotations = routeCoordinates.enumerated().map { (index, coordinate) -> PointAnnotation in
                var annotation = PointAnnotation(coordinate: coordinate)
                annotation.textField = pointTypes[index].rawValue
                annotation.textColor = .init(UIColor.red) // Usar UIColor para especificar el color
                return annotation
            }
            pointAnnotationManager?.annotations = pointAnnotations
            
            // Dibujar la ruta solo si hay dos o más puntos
            if routeCoordinates.count > 1 {
                var polyline = PolylineAnnotation(lineCoordinates: routeCoordinates)
                polyline.lineColor = .init(UIColor.red) // Cambiar color utilizando UIColor
                polyline.lineWidth = 5.0
                polylineAnnotationManager?.annotations = [polyline]
            }
        }

        // Calcula la distancia de la ruta
        func calculateDistance() {
            var totalDistance = 0.0
            for i in 1..<routeCoordinates.wrappedValue.count {
                let start = routeCoordinates.wrappedValue[i-1]
                let end = routeCoordinates.wrappedValue[i]
                totalDistance += start.distance(to: end)
            }
            distance.wrappedValue = totalDistance / 1000 // Convertir a kilómetros
        }

        // Manejo de la ubicación del usuario
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last, let mapView = mapView else { return }
            let userLocation = location.coordinate
            
            // Centrar la cámara en la ubicación del usuario
            let cameraOptions = CameraOptions(center: userLocation, zoom: 14)
            mapView.camera.ease(to: cameraOptions, duration: 1.0)
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                manager.startUpdatingLocation()
            }
        }
    }
}

// Extension para calcular distancia entre dos coordenadas
extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> Double {
        let start = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let end = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return start.distance(from: end)
    }
}
