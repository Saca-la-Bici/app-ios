import SwiftUI

struct EventView: View {
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @StateObject private var viewModel = ActividadViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.eventos.isEmpty {
                    Text("No estás inscrito en ningúna actividad.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.eventos, id: \.id) { evento in
                                // Aquí estás accediendo a la propiedad informacion de cada evento
                                let actividad = evento.informacion
                                ActivityCardSMView(
                                    id: actividad.id,
                                    activityTitle: actividad.titulo,
                                    activityType: actividad.tipo,
                                    level: evento.ruta?.nivel,
                                    date: FechaManager.shared.formatDate(actividad.fecha),
                                    time: actividad.hora,
                                    duration: actividad.duracion,
                                    imagen: actividad.imagen,
                                    location: actividad.ubicacion,
                                    attendees: actividad.personasInscritas
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.getActividades()
                    } catch {
                        showErrorAlert = true
                    }
                }
                
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
