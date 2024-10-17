import SwiftUI
import MapboxMaps
import CoreLocation
import MessageUI

struct MapaView: View {
    @StateObject private var viewModel = MailViewModel()
    @State private var showingSuccessMessage = false
    @State private var showingMailError = false // Para mostrar la alerta si no se puede enviar correos

    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapViewContainer()
                .ignoresSafeArea()

            Button(action: {
                if viewModel.canSendMail() {
                    viewModel.sendMail()
                } else {
                    showingMailError = true // Activar la alerta si no se puede enviar correos
                }
            }, label: {
                Image(systemName: "envelope")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            })
            .padding(.top, 60)
            .padding(.trailing, 20)
        }
        .sheet(isPresented: $viewModel.isShowingMailView, content: {
            if let mailData = viewModel.mailData {
                MailView(model: mailData) { result in
                    if result == .sent {
                        viewModel.isMailSent = true
                    }
                    showingSuccessMessage = viewModel.isMailSent
                }
                .onDisappear {
                    if viewModel.isMailSent {
                        showingSuccessMessage = true
                    }
                }
            }
        })
        .alert(isPresented: $showingSuccessMessage) {
            Alert(
                title: Text("Correo Enviado"),
                message: Text("El correo ha sido enviado con éxito."),
                dismissButton: .default(Text("OK"))
            )
        }
        // Agregar la alerta si no se puede enviar correos
        .alert(isPresented: $showingMailError) {
            Alert(
                title: Text("Error"),
                message: Text("Este dispositivo no puede enviar correos. Por favor, configure una cuenta de correo."),
                dismissButton: .default(Text("OK"))
            )
        }
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

        // Seguimiento de la ubicación del usuario
        let followPuckViewportState = mapView.viewport.makeFollowPuckViewportState()
        mapView.viewport.transition(to: followPuckViewportState)

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CLLocationManagerDelegate {
        var parent: MapViewContainer

        init(_ parent: MapViewContainer) {
            self.parent = parent
        }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Permisos de localización concedidos")
                manager.startUpdatingLocation()
            case .denied, .restricted:
                print("Permisos de localización denegados. Por favor, habilite los permisos en Configuración.")
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

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            print("Ubicación actualizada: \(location.coordinate)")
        }
    }
}
