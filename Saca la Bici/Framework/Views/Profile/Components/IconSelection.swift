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
            HStack(spacing: 120) {
                // Ícono de calendario
                Button(action: {
                    withAnimation {
                        selectedIcon = 0  // Calendario seleccionado
                    }
                }) {
                    VStack {
                        Image("Calendario")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }

                // Ícono de palomita (checkmark)
                Button(action: {
                    withAnimation {
                        selectedIcon = 1  // Palomita seleccionada
                    }
                }) {
                    VStack {
                        Image("Palomita")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }

                // Ícono de mundo
                Button(action: {
                    withAnimation {
                        selectedIcon = 2  // Mundo seleccionado
                    }
                }) {
                    VStack {
                        Image("Mundo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .padding(.bottom, 35)
            
            // ZStack para las vistas con animación de transición
            ZStack {
                if selectedIcon == 0 {
                    Text("Vista de Calendario")
                        .font(.title)
                        .transition(.slide)
                } else if selectedIcon == 1 {
                    VStack {
                        MedalsView()
                        EventView()
                    }
                    .transition(.slide)
                } else if selectedIcon == 2 {
                    Text("Vista de mundo")
                        .font(.title)
                        .transition(.slide)
                }
            }
            .offset(x: offset.width)  // Aplicar el desplazamiento
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation  // Detectar el desplazamiento
                    }
                    .onEnded { gesture in
                        if gesture.translation.width < -100 && selectedIcon < 2 {
                            // Deslizar a la izquierda
                            withAnimation {
                                selectedIcon += 1
                            }
                        } else if gesture.translation.width > 100 && selectedIcon > 0 {
                            // Deslizar a la derecha
                            withAnimation {
                                selectedIcon -= 1
                            }
                        }
                        // Restablecer el offset después del gesto
                        withAnimation {
                            offset = .zero
                        }
                    }
            )
            .animation(.easeInOut, value: selectedIcon)

            Spacer()
        }
        .padding()
    }
}
