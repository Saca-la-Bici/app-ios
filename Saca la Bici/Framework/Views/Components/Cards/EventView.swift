import SwiftUI
import Foundation

struct EventView: View {
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @StateObject private var viewModel = ActividadViewModel()

    var body: some View {
        NavigationView {
            VStack {

                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.eventos.allSatisfy({ inscripcion in
                    inscripcion.informacion.allSatisfy { !$0.estado }
                }) {
                    Text("No estás inscrito en ninguna actividad.")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            
                            var actividadesActivas: [(actividad: Actividad, actividadInscritaId: String)] {
                                viewModel.eventos.flatMap { actividadInscrita in
                                    actividadInscrita.informacion.filter { $0.estado }.map {
                                        (actividad: $0, actividadInscritaId: actividadInscrita._id)
                                    }
                                }
                            }

                            ForEach(actividadesActivas, id: \.actividad.id) { item in
                                ActivityCardSMView(
                                    id: item.actividadInscritaId,  // Aquí pasamos el _id de ActividadInscrita
                                    activityTitle: item.actividad.titulo,
                                    activityType: item.actividad.tipo,
                                    level: nil, // Puedes ajustar esto si tienes niveles
                                    date: FechaManager.shared.formatDate(item.actividad.fecha),
                                    time: item.actividad.hora,
                                    duration: item.actividad.duracion,
                                    imagen: item.actividad.imagen,
                                    location: item.actividad.ubicacion,
                                    attendees: item.actividad.personasInscritas
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
                        showErrorAlert = false
                        try await viewModel.getActividades()
                        
                    } catch {
                        showErrorAlert = true
                    }
                }
                
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Error al conseguir las actividades. Por favor, intenta más tarde"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        // .navigationViewStyle(StackNavigationViewStyle())
    }
}
