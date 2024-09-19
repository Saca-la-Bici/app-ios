//
//  AnadirAnuncioView.swift
//  template
//
//  Created by Diego Lira on 08/09/24.
//

import SwiftUI

struct AnadirAnuncioView: View {
    @State private var titulo: String = ""
    @State private var descripcion: String = ""
    @Environment(\.presentationMode) var presentationMode
    var viewModel: AnuncioViewModel

    var body: some View {
        VStack {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Añadir anuncio")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    if !titulo.isEmpty && !descripcion.isEmpty {
                        viewModel.registrarAnuncio(titulo: titulo, contenido: descripcion)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer().frame(height: 40)

            
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

            Spacer()
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    AnadirAnuncioView(viewModel: AnuncioViewModel())
}
