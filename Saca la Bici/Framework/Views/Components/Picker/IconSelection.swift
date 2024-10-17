//
//  IconSelection.swift
//  Saca la Bici
//
//  Created by Diego Lira on 03/10/24.
//

import SwiftUI

struct IconSelectionView: View {
    @State private var selectedIcon = 1
    @State private var offset: CGSize = .zero

    var body: some View {
        VStack {
            // Íconos para seleccionar la vista
            HStack(spacing: 100) {
                // Ícono de calendario
                Button {
                    withAnimation {
                        selectedIcon = 0
                    }
                } label: {
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(selectedIcon == 0 ? .yellow : .primary)
                }
                .buttonStyle(PlainButtonStyle())

                // Ícono de palomita (checkmark)
                Button {
                        withAnimation {
                            selectedIcon = 1
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .foregroundColor(selectedIcon == 1 ? .yellow : .primary)
                    }
                    .buttonStyle(PlainButtonStyle())

                // Ícono de mundo
                Button {
                        withAnimation {
                            selectedIcon = 2
                        }
                    } label: {
                        Image(systemName: "globe.americas")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(selectedIcon == 2 ? .yellow : .primary)
                    }
                    .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 15)
            
            // ZStack para las vistas con animación de transición
            ZStack {
                if selectedIcon == 0 {
                    VStack {
                        EventView()
                        Spacer()
                    }
                    .transition(.scale)
                    
                } else if selectedIcon == 1 {
                    VStack {
                        MedalsView()
                        Spacer()
                    }
                    .transition(.scale)
                } else if selectedIcon == 2 {
                    VStack {
                        ConsultarEstadisticasView()
                        Spacer()
                    }
                }
            }
            Spacer()
        }
        .padding()
    }
}
