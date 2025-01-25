//
//  talleresView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct TalleresView: View {
    @Binding var path: [ActivitiesPaths]
    @ObservedObject var actividadViewModel = ActividadViewModel()
    @ObservedObject var rodadasViewModel = RodadasViewModel()
    @ObservedObject var eventosViewModel = EventosViewModel()
    @ObservedObject var talleresViewModel = TalleresViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 5)
                if talleresViewModel.isLoading {
                    ProgressView()
                } else if talleresViewModel.talleres.isEmpty {
                    Text("Actualmente no hay talleres disponibles, pero vuelve más tarde para ver nuevas actividades.")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding()
                } else {
                    ForEach(talleresViewModel.talleres) { taller in
                        ActivityCardView(
                            path: $path,
                            id: taller.id,
                            activityTitle: taller.actividad.titulo,
                            activityType: "Taller",
                            date: FechaManager.shared.formatDate(taller.actividad.fecha),
                            time: taller.actividad.hora,
                            duration: taller.actividad.duracion,
                            imagen: taller.actividad.imagen,
                            location: taller.actividad.ubicacion,
                            attendees: taller.actividad.personasInscritas,
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
            talleresViewModel.isLoading = true
            talleresViewModel.fetchTalleres()
        }
    }
}
