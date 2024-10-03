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
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var existingImageURL: URL?
    @State private var existingImageData: Data?

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
        if let imageUrlString = anuncio.imagen, let url = URL(string: imageUrlString) {
            _existingImageURL = State(initialValue: url)
        }
    }

    var body: some View {
        VStack {
            // Encabezado
            HStack {
                Button(action: {
                    // Acción para cerrar la vista
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                })
                .buttonStyle(PlainButtonStyle())

                Spacer()
                Text("Modificar anuncio")
                    .font(.headline)
                Spacer()
                Button(action: {
                    // Validaciones
                    if titulo.trimmingCharacters(in: .whitespaces).isEmpty {
                        viewModel.errorMessage = "El título no puede estar vacío."
                        activeAlert = .validationError
                        return
                    }
                    if contenido.trimmingCharacters(in: .whitespaces).isEmpty {
                        viewModel.errorMessage = "La descripción no puede estar vacía."
                        activeAlert = .validationError
                        return
                    }

                    // Determinar qué imagen enviar
                    let imagenAEnviar = selectedImageData ?? existingImageData

                    // Llamar al ViewModel para modificar el anuncio
                    Task {
                        await viewModel.modificarAnuncio(
                            anuncio: anuncio,
                            nuevoTitulo: titulo,
                            nuevoContenido: contenido,
                            imagenData: imagenAEnviar
                        )
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

            // Manejo de la imagen
            if selectedImageData == nil && existingImageURL == nil {
                // Si no hay imagen seleccionada ni existente, mostrar el picker
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
                           UIImage(data: data) != nil {
                            selectedImageData = data
                        }
                    }
                }
            } else if let data = selectedImageData, let uiImage = UIImage(data: data) {
                // Mostrar la imagen seleccionada
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
            } else if let imageURL = existingImageURL {
                // Mostrar la imagen existente
                VStack {
                    AsyncImage(url: imageURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                        } else if phase.error != nil {
                            // Error al cargar la imagen
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                        } else {
                            // Placeholder mientras se carga la imagen
                            ProgressView()
                                .frame(width: 200, height: 200)
                        }
                    }

                    HStack {
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared(),
                            label: {
                                Text("Cambiar Imagen")
                                    .foregroundColor(.blue)
                                    .padding(.top, 5)
                            }
                        )
                        .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            // Eliminar la imagen existente
                            selectedImageData = nil
                            existingImageURL = nil
                            existingImageData = nil
                        }, label: {
                            Text("Eliminar Imagen")
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        })
                    }
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           UIImage(data: data) != nil {
                            selectedImageData = data
                            existingImageURL = nil
                            existingImageData = nil
                        }
                    }
                }
            }

            Spacer().frame(height: 20)

            // Campo de texto para el título
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

            // Campo de texto para el contenido
            VStack(alignment: .leading) {
                Text("Descripción")
                    .font(.subheadline)
                
                TextoLimiteMultilineField(
                    placeholder: "¿Qué quieres compartir?",
                    text: $contenido,
                    maxLength: 450,
                    showCharacterCount: true
                )
            }
            .padding(.horizontal)
            .padding(.bottom, 20)

            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
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
        .onChange(of: viewModel.errorMessage) { _, newValue in
            if newValue != nil {
                activeAlert = .errorGeneral
            }
        }
        // Observa cambios en successMessage para mostrar la alerta de éxito
        .onChange(of: viewModel.successMessage) { _, newValue in
            if newValue != nil {
                activeAlert = .success
            }
        }
        .onAppear {
            if let url = existingImageURL, existingImageData == nil {
                Task {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        existingImageData = data
                    } catch {
                        print("Error al descargar la imagen existente: \(error)")
                    }
                }
            }
        }
    }
}
