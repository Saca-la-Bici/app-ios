//
//  eventosView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct EventosView: View {
    @Binding var path: [ActivitiesPaths]
    @ObservedObject var actividadViewModel = ActividadViewModel()
    @ObservedObject var rodadasViewModel = RodadasViewModel()
    @ObservedObject var eventosViewModel = EventosViewModel()
    @ObservedObject var talleresViewModel = TalleresViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 5)
                if eventosViewModel.isLoading {
                    ProgressView()
                } else if eventosViewModel.eventos.isEmpty {
                    Text("Actualmente no hay eventos disponibles, pero vuelve más tarde para ver nuevas actividades.")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding()
                } else {
                    ForEach(eventosViewModel.eventos) { evento in
                        ActivityCardView(
                            path: $path,
                            id: evento.id,
                            activityTitle: evento.actividad.titulo,
                            activityType: "Evento",
                            date: FechaManager.shared.formatDate(evento.actividad.fecha),
                            time: evento.actividad.hora,
                            duration: evento.actividad.duracion,
                            imagen: evento.actividad.imagen,
                            location: evento.actividad.ubicacion,
                            attendees: evento.actividad.personasInscritas,
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
            eventosViewModel.isLoading = true
            eventosViewModel.fetchEventos()
        }
    }
}
