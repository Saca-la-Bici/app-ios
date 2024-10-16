//
//  IconSelection.swift
//  Saca la Bici
//
//  Created by Diego Lira on 03/10/24.
//

import SwiftUI

struct IconSelectionView: View {
    @Binding var path: [ActivitiesPaths]
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
            .padding(.bottom, 35)
            
            // ZStack para las vistas con animación de transición
            ZStack {
                if selectedIcon == 0 {
                    VStack {
                        EventView(path: $path)
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
                    Text("Vista de mundo")
                        .font(.title)
                        .transition(.scale)
                    Spacer()
                }
            }
            .offset(x: offset.width)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = gesture.translation
                    }
                    .onEnded { gesture in
                        if gesture.translation.width < -100 && selectedIcon < 2 {
                            withAnimation {
                                selectedIcon += 1
                            }
                        } else if gesture.translation.width > 100 && selectedIcon > 0 {
                            withAnimation {
                                selectedIcon -= 1
                            }
                        }
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
