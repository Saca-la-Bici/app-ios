//
//  AnadirAnuncioView.swift
//  Template
//
//  Created by Diego Lira on 08/09/24.
//

import SwiftUI
import PhotosUI
import FirebaseAuth

struct AnadirAnuncioView: View {
    @State private var titulo: String = ""
    @State private var descripcion: String = ""
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AnuncioViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    // Enum para manejar las alertas activas
    enum ActiveAlert: Identifiable {
        case error
        case success
        case notAuthenticated

        var id: Int {
            hashValue
        }
    }
    
    // Variable de estado para la alerta activa
    @State private var activeAlert: ActiveAlert?
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                })
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Text("Añadir anuncio")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    // Validaciones
                    if titulo.trimmingCharacters(in: .whitespaces).isEmpty {
                        viewModel.errorMessage = "El título no puede estar vacío."
                        activeAlert = .error
                        return
                    }
                    if descripcion.trimmingCharacters(in: .whitespaces).isEmpty {
                        viewModel.errorMessage = "La descripción no puede estar vacía."
                        activeAlert = .error
                        return
                    }
                    
                    // Verificar autenticación
                    if !viewModel.isUserAuthenticated {
                        viewModel.errorMessage = "Debes iniciar sesión para añadir un anuncio."
                        activeAlert = .notAuthenticated
                        return
                    }
                    
                    // Llamar al ViewModel para registrar el anuncio de forma asincrónica
                    Task {
                        await viewModel.registrarAnuncio(titulo: titulo, contenido: descripcion)
                    }
                }, label: {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundColor(.yellow)
                })
                .buttonStyle(PlainButtonStyle())
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
                .onChange(of: selectedItem) { _, newItem in
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
                    }, label: {
                        Text("Eliminar Imagen")
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    })
                }
            }

            Spacer().frame(height: 20)
            
            // Título
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

            // Descripción
            VStack(alignment: .leading) {
                Text("Descripción")
                    .font(.subheadline)
                    .foregroundColor(.black)

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $descripcion)
                        .padding(8)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.top, 5)

                    if descripcion.isEmpty {
                        Text("¿Qué quieres compartir?")
                            .foregroundColor(Color(.placeholderText))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 16)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .padding(.bottom, 20)
        // Alerta
        .alert(item: $activeAlert) { alertType in
            switch alertType {
            case .error:
                return Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "Error desconocido."),
                    dismissButton: .default(Text("OK")) {
                        viewModel.errorMessage = nil
                    }
                )
            case .success:
                return Alert(
                    title: Text("Éxito"),
                    message: Text(viewModel.successMessage ?? "Anuncio agregado correctamente."),
                    dismissButton: .default(Text("OK")) {
                        viewModel.successMessage = nil
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            case .notAuthenticated:
                return Alert(
                    title: Text("No autenticado"),
                    message: Text(viewModel.errorMessage ?? "Debes iniciar sesión para realizar esta acción."),
                    dismissButton: .default(Text("OK")) {
                        viewModel.errorMessage = nil
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
        // Observa cambios en successMessage para mostrar la alerta de éxito
        .onChange(of: viewModel.successMessage) { _, newValue in
            if newValue != nil {
                activeAlert = .success
            }
        }
        // Observa cambios en errorMessage para mostrar la alerta de error o notAuthenticated
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if newValue != nil {
                if viewModel.isUserAuthenticated {
                    activeAlert = .error
                } else {
                    activeAlert = .notAuthenticated
                }
            }
        }
    }
}

#Preview {
    AnadirAnuncioView(viewModel: AnuncioViewModel())
}
