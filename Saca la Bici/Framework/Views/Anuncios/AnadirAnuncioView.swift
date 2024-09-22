//
//  AnadirAnuncioView.swift
//  template
//
//  Created by Diego Lira on 08/09/24.
//

import SwiftUI
import PhotosUI

struct AnadirAnuncioView: View {
    @State private var titulo: String = ""
    @State private var descripcion: String = ""
    @Environment(\.presentationMode) var presentationMode
    var viewModel: AnuncioViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil


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

            // Icono para subir imagen utilizando PhotosPicker
                       if selectedImageData == nil {
                           PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
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
                           .onChange(of: selectedItem) { newItem in
                               Task {
                                   if let data = try? await newItem?.loadTransferable(type: Data.self),
                                      let uiImage = UIImage(data: data) {
                                       selectedImageData = data
                                   }
                               }
                           }
                       }

                       // Mostrar la imagen seleccionada si existe
                       if let data = selectedImageData, let uiImage = UIImage(data: data) {
                           VStack {
                               Image(uiImage: uiImage)
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 200, height: 200)
                                   .cornerRadius(10)
                               
                               
                               Button(action: {
                                   selectedImageData = nil
                               }) {
                                   Text("Eliminar Imagen")
                                       .foregroundColor(.red)
                                       .padding(.top, 5)
                               }
                           }
                       }

                       Spacer().frame(height: 20)
            
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
