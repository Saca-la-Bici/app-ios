import SwiftUI
import Foundation

struct EventView: View {
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @StateObject private var viewModel = ActividadViewModel()
    
    @Binding var path: [ConfigurationPaths]

    var body: some View {
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
                            
                        var actividadesActivas: [(actividad: Actividad, actividadInscritaId: String, ruta: Ruta?)] {
                            let calendar = Calendar.current
                            let todayStart = calendar.startOfDay(for: Date())

                            return viewModel.eventos.flatMap { actividadInscrita in
                                actividadInscrita.informacion
                                    .filter { actividadFiltrada in
                                        let fechaString = actividadFiltrada.fecha
                                            
                                        guard let date = FechaManager.shared.parseISODate(fechaString) else {
                                            return false
                                        }
                                        
                                        let activityStartOfDay = calendar.startOfDay(for: date)
                                        return actividadFiltrada.estado && activityStartOfDay >= todayStart
                                    }
                                    .map { actividadFiltrada in
                                        (
                                            actividad: actividadFiltrada,
                                            actividadInscritaId: actividadInscrita._id,
                                            ruta: actividadInscrita.ruta
                                        )
                                    }
                            }
                        }

                        ForEach(actividadesActivas, id: \.actividad.id) { item in
                            ActivityCardSMView(
                                id: item.actividadInscritaId,
                                activityTitle: item.actividad.titulo,
                                activityType: item.actividad.tipo,
                                level: item.ruta?.nivel ?? nil,
                                date: FechaManager.shared.formatDate(item.actividad.fecha),
                                time: item.actividad.hora,
                                duration: item.actividad.duracion,
                                imagen: item.actividad.imagen,
                                location: item.actividad.ubicacion,
                                attendees: item.actividad.personasInscritas,
                                path: $path
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
}
