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
                })
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Text("Añadir anuncio")
                    .font(.headline)
              
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
                    
                    // Llamar al ViewModel para registrar el anuncio de forma asincrónica
                    Task {
                        await viewModel.registrarAnuncio(titulo: titulo, contenido: descripcion, imagenData: selectedImageData)
                    }
                }, label: {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
                })
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            .padding(.top, 10)
    
            Spacer().frame(height: 40)

            // Componenete del picker
            ImagePickerView(selectedItem: $selectedItem, selectedImageData: $selectedImageData)

            Spacer().frame(height: 20)
            
            // Título
            VStack(alignment: .leading) {
                TextoLimiteField(
                    label: "Título",
                    placeholder: "Escribe el título del anuncio ...",
                    text: $titulo,
                    maxLength: 80,
                    title: false,
                    subheadline: true
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 20)

            // Descripción
            VStack(alignment: .leading) {
                Text("Descripción")
                    .font(.subheadline)
                
                TextoLimiteMultilineField(
                    placeholder: "¿Qué quieres compartir?",
                    text: $descripcion,
                    maxLength: 450,
                    showCharacterCount: true
                )
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
                activeAlert = .error
            }
        }
    }
}

#Preview {
    AnadirAnuncioView(viewModel: AnuncioViewModel())
}
