//
//  actividadesUsuario.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct ActividadesView: View {
    @State private var selectedTab: String = "Rodadas"
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Image("logoB&N")
                        .resizable()
                        .frame(width: 44, height: 35)
                        .padding(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "questionmark.circle")
                    
                    Image(systemName: "bell")
                        .padding(.trailing)
                    
                }
                .padding()

                Text("Actividades")
                    .font(.title3)
                    .bold()
            }

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
            .tint(Color.yellow)
            
            // Conditional Views
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
            
            Spacer()
        }
        .background(Color(.systemGray6))
    }
}

struct ActividadesView_Previews: PreviewProvider {
    static var previews: some View {
        ActividadesView()
    }
}
