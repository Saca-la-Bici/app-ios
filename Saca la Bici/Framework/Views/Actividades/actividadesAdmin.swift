//
//  actividadesAdmin.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct AdminView: View {
    @State private var selectedTab: String = "Rodadas" // Estado para el Picker
    
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
                        .foregroundColor(.black)
                    
                    Image(systemName: "bell")
                        .foregroundColor(.black)
                    
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(.trailing)
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
            
            // Vistas condicionales basadas en la selección del Picker
            Group {
                if selectedTab == "Rodadas" {
                    RodadasAdminView()
                } else if selectedTab == "Eventos" {
                    EventosAdminView()
                } else if selectedTab == "Talleres" {
                    TalleresAdminView()
                }
            }
            .transition(.opacity)
            
            Spacer()
        }
        .background(Color(.systemGray6))
    }
}

struct RodadasAdminView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Ejemplo de tarjeta de actividad
                ActivityCardAdminView(
                    activityTitle: "Rodada Nocturna",
                    activityType: "Rodada",
                    level: "Nivel 1",
                    date: "Sábado 24 agosto 2024",
                    time: "19:00",
                    duration: "1 hrs",
                    location: "Centro histórico",
                    attendees: 67
                )
            }
            .padding(.horizontal)
        }
    }
}

struct EventosAdminView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Ejemplo de tarjeta de actividad
                ActivityCardAdminView(
                    activityTitle: "Día Mundial del Medio Ambiente",
                    activityType: "Evento",
                    date: "Jueves 5 junio 2025",
                    time: "13:00",
                    location: "Epigmenio González",
                    attendees: 32
                )
                // Agrega más tarjetas o contenido aquí
            }
            .padding(.horizontal)
        }
    }
}

struct TalleresAdminView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Ejemplo de tarjeta de actividad
                ActivityCardAdminView(
                    activityTitle: "Taller de Mantenimiento de Bicicletas",
                    activityType: "Taller",
                    date: "Lunes 10 julio 2025",
                    time: "10:00",
                    location: "Parque Central",
                    attendees: 20
                )
                // Agrega más tarjetas o contenido aquí
            }
            .padding(.horizontal)
        }
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
