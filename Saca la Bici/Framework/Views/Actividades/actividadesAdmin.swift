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
                    
                    Image(systemName: "bell")
                    
                    Image(systemName: "plus")
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

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
