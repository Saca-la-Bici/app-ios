//
//  ProfileEvents.swift
//  Saca la Bici
//
//  Created by Diego Lira on 03/10/24.
//

import SwiftUI

struct EventView: View {
    @Binding var path: [ActivitiesPaths]
    @StateObject private var viewModel = EventosViewModel()

    var body: some View {
        
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
                            ActivityCardView(
                                path: $path,
                                id: evento.id,
                                activityTitle: evento.actividad.titulo,
                                activityType: evento.actividad.tipo,
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
        .onAppear {
            viewModel.fetchEventosFiltrados()
        }
    }
}
