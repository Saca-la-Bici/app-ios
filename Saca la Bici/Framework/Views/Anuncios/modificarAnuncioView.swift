//
//  modificarAnuncioView.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 21/09/24.
//

import SwiftUI

struct ModificarAnuncioView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AnuncioViewModel
    var anuncio: Anuncio

    @State private var titulo: String
    @State private var contenido: String
    @State private var showValidationError = false
    @State private var validationErrorMessage = ""
    @State private var showSuccessAlert = false

    // Inicializador personalizado
    init(viewModel: AnuncioViewModel, anuncio: Anuncio) {
        self.viewModel = viewModel
        self.anuncio = anuncio
        _titulo = State(initialValue: anuncio.titulo)
        _contenido = State(initialValue: anuncio.contenido)
    }

    var body: some View {
        VStack {
            // Header
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
                        validationErrorMessage = "El título no puede estar vacío."
                        showValidationError = true
                        return
                    }
                    if contenido.trimmingCharacters(in: .whitespaces).isEmpty {
                        validationErrorMessage = "El contenido no puede estar vacío."
                        showValidationError = true
                        return
                    }
                    
                    // Llamar al ViewModel para modificar el anuncio
                    viewModel.modificarAnuncio(
                        anuncio: anuncio,
                        nuevoTitulo: titulo,
                        nuevoContenido: contenido
                    )
                    
                    // Mostrar alerta de éxito
                    showSuccessAlert = true
                }) {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer().frame(height: 40)

            // Icono para subir imagen (opcional)
            Button(action: {
                // Acción para subir imagen
                // Implementar lógica para seleccionar y subir una nueva imagen
                // Por ejemplo, usar UIImagePickerController o alguna librería de selección de imágenes
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)

                    // Si tienes una imagen, muéstrala; de lo contrario, muestra el icono por defecto
                    if let imagenURL = anuncio.imagen, !imagenURL.isEmpty {
                        AsyncImage(url: URL(string: imagenURL)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                    } else {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.gray.opacity(0.1))
                    }

                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.white.opacity(0.7))
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
                    if contenido.isEmpty {
                        Text("¿Qué quieres compartir?")
                            .foregroundColor(Color(.placeholderText))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 12)
                    }
                    TextEditor(text: $contenido)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.top, 5)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)

            Spacer()
        }
        .padding(.bottom, 20)
        .alert(isPresented: $showValidationError) {
            Alert(title: Text("Error"), message: Text(validationErrorMessage), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Éxito"),
                message: Text("El anuncio ha sido modificado correctamente."),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    struct ModificarAnuncioView_Previews: PreviewProvider {
        static var previews: some View {
            let viewModel = AnuncioViewModel()
            let ejemploAnuncio = Anuncio(
                id: "12345",
                IDUsuario: 1,
                titulo: "Ejemplo",
                contenido: "Descripción del ejemplo",
                imagen: nil,
                createdAt: "2024-09-21T12:00:00Z",
                fechaCaducidad: "2024-10-21",
                icon: "A",
                backgroundColor: Color(UIColor.systemGray6)
            )
            ModificarAnuncioView(viewModel: viewModel, anuncio: ejemploAnuncio)
        }
    }
}
