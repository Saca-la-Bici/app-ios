//
//  rodadasView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct RodadasView: View {
    @Binding var path: [ActivitiesPaths]
    @ObservedObject var actividadViewModel = ActividadViewModel()
    @ObservedObject var rodadasViewModel = RodadasViewModel()
    @ObservedObject var eventosViewModel = EventosViewModel()
    @ObservedObject var talleresViewModel = TalleresViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 5)
                if rodadasViewModel.isLoading {
                    ProgressView()
                } else if rodadasViewModel.rodadas.isEmpty {
                    Text("Actualmente no hay rodadas disponibles, pero vuelve más tarde para ver nuevas actividades.")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding()
                } else {
                    ForEach(rodadasViewModel.rodadas) { rodada in
                        ActivityCardView(
                            path: $path,
                            id: rodada.id,
                            activityTitle: rodada.actividad.titulo,
                            activityType: "Rodada", 
                            level: rodada.ruta.nivel,
                            date: FechaManager.shared.formatDate(rodada.actividad.fecha),
                            time: rodada.actividad.hora,
                            duration: rodada.actividad.duracion,
                            imagen: rodada.actividad.imagen,
                            location: rodada.actividad.ubicacion,
                            attendees: rodada.actividad.personasInscritas,
                            actividadViewModel: actividadViewModel,
                            rodadasViewModel: rodadasViewModel,
                            talleresViewModel: talleresViewModel,
                            eventosViewModel: eventosViewModel
                        )
                    }
                }
                
                Spacer().frame(height: 5)
            }
            .padding(.horizontal)
        }
        .onAppear {
            rodadasViewModel.isLoading = true
            rodadasViewModel.fetchRodadas()
        }
    }
}
