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
                    Text("No estás inscrito en ningún evento.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.eventos) { evento in
                                ActivityCardSMView(
                                    id: evento.id,
                                    activityTitle: evento.actividad.titulo,
                                    activityType: evento.actividad.tipo,
                                    level: evento.actividad.nivel,
                                    date: FechaManager.shared.formatDate(evento.actividad.fecha),
                                    time: evento.actividad.hora,
                                    duration: evento.actividad.duracion,
                                    imagen: evento.actividad.imagen,
                                    location: evento.actividad.ubicacion,
                                    attendees: evento.actividad.personasInscritas
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Eventos")
            .onAppear {
                viewModel.getActividades()
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
