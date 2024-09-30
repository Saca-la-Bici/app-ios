//
//  ActividadesView.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 29/09/24.
//

import SwiftUI

struct ActividadesView: View {
    @State private var selectedTab: String = "Rodadas"
    @ObservedObject private var userSessionManager = UserSessionManager.shared

    var body: some View {
        VStack {
            // Encabezado
            ZStack {
                HStack {
                    Image("logoB&N")
                        .resizable()
                        .frame(width: 44, height: 35)
                        .padding(.leading)

                    Spacer()

                    Image(systemName: "questionmark.circle")
                        .padding(.trailing, 8)

                    Image(systemName: "bell")
                        .padding(.trailing, 8)
                    
                    if userSessionManager.puedeIniciarRodada() {
                        Image(systemName: "plus") // Solo para admin
                            .padding(.trailing, 8)
                    }
                    
                }
                .padding()

                Text("Actividades")
                    .font(.title3)
                    .bold()
            }

            // Picker para seleccionar la vista
            Picker("Select View", selection: $selectedTab) {
                Text("Rodadas")
                    .tag("Rodadas")
                Text("Eventos")
                    .tag("Eventos")
                Text("Talleres")
                    .tag("Talleres")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.bottom)
            
            // Mostrar las actividades según la pestaña seleccionada
            Group {
                if selectedTab == "Rodadas" {
                    RodadasView()
                } else if selectedTab == "Eventos" {
                    EventosView()
                } else if selectedTab == "Talleres" {
                    TalleresView()
                }
            }
            .transition(.opacity)
        }
    }
}
