import SwiftUI
import MapboxMaps
import CoreLocation
import MapboxDirections

struct MapViewContainer: UIViewRepresentable {
    @Binding var routeCoordinates: [CLLocationCoordinate2D]
    @Binding var distance: Double
    let locationManager = CLLocationManager()

    let directions: Directions = {
        guard let accessToken = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            fatalError("Mapbox access token is missing in Info.plist")
        }
        return Directions(credentials: Credentials(accessToken: accessToken))
    }()

    func makeUIView(context: Context) -> MapView {
        let mapInitOptions = MapInitOptions(styleURI: .streets)
        let mapView = MapView(frame: .zero, mapInitOptions: mapInitOptions)
        
        let queretaroCoordinates = CLLocationCoordinate2D(latitude: 20.5888, longitude: -100.3899)
        let cameraOptions = CameraOptions(center: queretaroCoordinates, zoom: 14)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        
        locationManager.delegate = context.coordinator
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        var locationOptions = LocationOptions()
        locationOptions.puckType = .puck2D()
        mapView.location.options = locationOptions
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        context.coordinator.mapView = mapView
        context.coordinator.setupAnnotationManagers()
        
        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        if routeCoordinates.count == 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                context.coordinator.getRoute()
            }
        }
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

        init(_ parent: MapViewContainer, routeCoordinates: Binding<[CLLocationCoordinate2D]>, distance: Binding<Double>) {
            self.parent = parent
            self.routeCoordinates = routeCoordinates
            self.distance = distance
        }

        func setupAnnotationManagers() {
            guard let mapView = mapView else { return }
            pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
            polylineAnnotationManager = mapView.annotations.makePolylineAnnotationManager()
        }

        @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
            guard let mapView = mapView else { return }
            let location = sender.location(in: mapView)
            let coordinate = mapView.mapboxMap.coordinate(for: location)
            
            if routeCoordinates.wrappedValue.count < 3 {
                routeCoordinates.wrappedValue.append(coordinate)
                addMarker(at: coordinate, index: routeCoordinates.wrappedValue.count - 1)
                print("Punto agregado: \(coordinate)")
                
                if routeCoordinates.wrappedValue.count == 3 {
                    print("Se han seleccionado los 3 puntos. Calculando ruta...")
                }
            } else {
                print("Solo se permiten tres puntos: inicio, descanso y fin.")
            }
        }

        // Función para agregar un marcador en el mapa
        func addMarker(at coordinate: CLLocationCoordinate2D, index: Int) {
            guard let pointAnnotationManager = pointAnnotationManager else {
                print("PointAnnotationManager no está inicializado.")
                return
            }
            
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            
            // Definir colores diferentes para los marcadores (inicio, descanso y final)
            switch index {
            case 0:
                pointAnnotationManager.annotations.append(makePointAnnotation(at: coordinate, color: .black))  // Inicio
            case 1:
                pointAnnotationManager.annotations.append(makePointAnnotation(at: coordinate, color: .gray))   // Descanso
            case 2:
                pointAnnotationManager.annotations.append(makePointAnnotation(at: coordinate, color: .red))    // Final
            default:
                break
            }
        }

        // Función para crear un PointAnnotation con un color específico
        func makePointAnnotation(at coordinate: CLLocationCoordinate2D, color: UIColor) -> PointAnnotation {
            var pointAnnotation = PointAnnotation(coordinate: coordinate)
            pointAnnotation.iconColor = StyleColor(color)
            return pointAnnotation
        }

        func getRoute() {
            print("Iniciando cálculo de ruta...")
            print("Número de puntos seleccionados: \(routeCoordinates.wrappedValue.count)")
            
            guard routeCoordinates.wrappedValue.count == 3 else {
                print("Número incorrecto de puntos para calcular la ruta.")
                return
            }
            
            let waypoints = routeCoordinates.wrappedValue.map { Waypoint(coordinate: $0) }
            
            // Verifica las coordenadas de los waypoints seleccionados
            waypoints.forEach { waypoint in
                print("Waypoint: \(waypoint.coordinate.latitude), \(waypoint.coordinate.longitude)")
            }
            
            let options = RouteOptions(waypoints: waypoints, profileIdentifier: .cycling)

            parent.directions.calculate(options) { (_, result) in
                switch result {
                case .failure(let error):
                    print("Error calculando la ruta: \(error.localizedDescription)")
                case .success(let response):
                    guard let route = response.routes?.first else {
                        print("No se encontró ninguna ruta.")
                        return
                    }
                    print("Ruta obtenida: \(route)")
                    
                    if let geometry = route.shape {
                        print("Geometría de la ruta: \(geometry)")
                        DispatchQueue.main.async {
                            self.drawRoute(geometry.coordinates)
                            self.distance.wrappedValue = route.distance / 1000 // Convertir a kilómetros
                        }
                    } else {
                        print("No se encontró geometría en la ruta.")
                    }
                }
            }
        }

        func drawRoute(_ routeCoordinates: [CLLocationCoordinate2D]) {
            guard let polylineAnnotationManager = polylineAnnotationManager else {
                print("PolylineAnnotationManager no está inicializado.")
                return
            }
            
            polylineAnnotationManager.annotations = []
            
            if routeCoordinates.isEmpty {
                print("Error: Las coordenadas de la ruta están vacías.")
                return
            } else {
                print("Dibujando ruta con \(routeCoordinates.count) coordenadas.")
            }

            var polyline = PolylineAnnotation(lineCoordinates: routeCoordinates)
            polyline.lineColor = StyleColor(.blue)
            polyline.lineWidth = 2.5
            
            polylineAnnotationManager.annotations.append(polyline)
            print("Ruta dibujada en el mapa.")
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let userLocation = location.coordinate
            
            let cameraOptions = CameraOptions(center: userLocation, zoom: 14)
            mapView?.camera.ease(to: cameraOptions, duration: 1.0)
        }

        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                manager.startUpdatingLocation()
            } else {
                print("Permiso de ubicación no otorgado.")
            }
        }
    }
}
