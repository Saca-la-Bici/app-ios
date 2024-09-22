//
//  modificarAnuncioView.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 21/09/24.
//

import SwiftUI

struct modificarAnuncioView: View {
    @State private var titulo: String = ""
    @State private var descripcion: String = ""

    var body: some View {
        VStack {
            // Header
            HStack {
                Button(action: {
                    // Acción para cerrar la vista
            }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Modificar anuncio")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    // Acción para confirmar el anuncio
                }) {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer().frame(height: 40)

            // Icono para subir imagen
            Button(action: {
                // Acción para subir imagen
            }) {
                ZStack {
                        // Fondo más claro
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        // Ícono de imagen detrás de la cruz
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.gray.opacity(0.1)) // Ícono de imagen más tenue
                        
                        // Ícono de cruz
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.white.opacity(0.7)) // Cruz blanca
                    }
            }

            Spacer().frame(height: 20)

            // Campo de texto para el título
            VStack(alignment: .leading) {
                Text("Título")
                    .font(.subheadline)
                    .foregroundColor(.black)

                TextField("Título del anuncio", text: $titulo)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            .padding(.bottom, 20)

            // Campo de texto para la descripción
            VStack(alignment: .leading) {
                        Text("Descripción")
                            .font(.subheadline)
                            .foregroundColor(.black)

                        ZStack(alignment: .topLeading) {
                            if descripcion.isEmpty {
                                Text("¿Qué quieres compartir?")
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 12)
                            }
                            TextEditor(text: $descripcion)
                                .frame(height: 150)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                )
                                .padding(.top, 5)
                        }
                    }
                    .padding(.horizontal)
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                    }

            Spacer()

        }
        .padding(.bottom, 20)
    }
}

#Preview {
    modificarAnuncioView()
}
