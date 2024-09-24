//
//  modificarAnuncioView.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 21/09/24.
//

import SwiftUI
import PhotosUI

struct ModificarAnuncioView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AnuncioViewModel
    var anuncio: Anuncio
    
    @State private var titulo: String
    @State private var contenido: String
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    // Enum para manejar las alertas activas
    enum ActiveAlert: Identifiable {
        case validationError
        case success
        case errorGeneral

        var id: Int {
            hashValue
        }
    }
    
    // Variable de estado para la alerta activa
    @State private var activeAlert: ActiveAlert?
    
    // Inicializador personalizado
    init(viewModel: AnuncioViewModel, anuncio: Anuncio) {
        self.viewModel = viewModel
        self.anuncio = anuncio
        _titulo = State(initialValue: anuncio.titulo)
        _contenido = State(initialValue: anuncio.contenido)
    }
    
    var body: some View {
        VStack {
            // Encabezado
            HStack {
                Button(action: {
                    // Acción para cerrar la vista
                    presentationMode.wrappedValue.dismiss()
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
                    // Validaciones
                    if titulo.trimmingCharacters(in: .whitespaces).isEmpty {
                        viewModel.errorMessage = "El título no puede estar vacío."
                        activeAlert = .validationError
                        return
                    }
                    if contenido.trimmingCharacters(in: .whitespaces).isEmpty {
                        viewModel.errorMessage = "El contenido no puede estar vacío."
                        activeAlert = .validationError
                        return
                    }
                    
                    // Llamar al ViewModel para modificar el anuncio
                    viewModel.modificarAnuncio(
                        anuncio: anuncio,
                        nuevoTitulo: titulo,
                        nuevoContenido: contenido
                    )
                }) {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Spacer().frame(height: 40)
            
            // Icono para subir una imagen
            if selectedImageData == nil {
                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.gray.opacity(0.1))
                        
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.white.opacity(0.7))
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

            // Mostrar la imagen si existe
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
            
            // Campo de texto para el contenido
            VStack(alignment: .leading) {
                Text("Contenido")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $contenido)
                        .padding(8)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.top, 5)
                    
                    // Mostrar placeholder cuando el contenido está vacío
                    if contenido.isEmpty {
                        Text("¿Qué quieres compartir?")
                            .foregroundColor(Color(.placeholderText))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
    
            Spacer()
        }
        .padding(.bottom, 20)
        // Único modificador de alerta utilizando activeAlert
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .validationError:
                return Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Error de validación."),
                    dismissButton: .default(Text("OK")) {
                        // Limpiar el mensaje de error si es necesario
                        viewModel.errorMessage = nil
                    }
                )
            case .errorGeneral:
                return Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Ha ocurrido un error."),
                    dismissButton: .default(Text("OK")) {
                        // Limpiar el mensaje de error
                        viewModel.errorMessage = nil
                    }
                )
            case .success:
                return Alert(
                    title: Text("Éxito"),
                    message: Text(viewModel.successMessage ?? "El anuncio ha sido modificado correctamente."),
                    dismissButton: .default(Text("OK")) {
                        // Limpiar el mensaje de éxito y cerrar la vista
                        viewModel.successMessage = nil
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
        // Observa cambios en errorMessage para mostrar la alerta de error
        .onChange(of: viewModel.errorMessage) { newValue in
            if newValue != nil {
                activeAlert = .errorGeneral
            }
        }
        // Observa cambios en successMessage para mostrar la alerta de éxito
        .onChange(of: viewModel.successMessage) { newValue in
            if newValue != nil {
                activeAlert = .success
            }
        }
    }
}
