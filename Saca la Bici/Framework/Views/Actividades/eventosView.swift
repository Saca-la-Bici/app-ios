//
//  eventosView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct EventosView: View {
    @StateObject private var viewModel = EventosViewModel()
    @ObservedObject private var userSessionManager = UserSessionManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Spacer().frame(height: 5)
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ForEach(viewModel.eventos) { evento in
                        ActivityCardView(
                            activityTitle: evento.actividad.titulo,
                            activityType: "Evento",
                            date: FechaManager.shared.formatDate(evento.actividad.fecha),
                            time: evento.actividad.hora,
                            location: evento.actividad.ubicacion,
                            attendees: evento.actividad.personasInscritas
                        )
                    }
                }
                Spacer().frame(height: 5)
            }
            .padding(.horizontal)
        }
    }
}
