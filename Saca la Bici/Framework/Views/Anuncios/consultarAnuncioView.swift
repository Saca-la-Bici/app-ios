//
//  consultarAnuncio.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 04/09/24.
//

import SwiftUI

struct ConsultarAnuncio: View {
    @StateObject private var viewModel = AnuncioViewModel()
    @ObservedObject private var userSessionManager = UserSessionManager.shared
    @State private var showAddAnuncioView = false
    @State private var alertMessage = ""
    @State private var showDeleteConfirmation = false
    @State private var selectedAnuncio: Anuncio?
    @State private var showModifyView = false

    var body: some View {
        VStack {
            // Encabezado
            ZStack {
                HStack {
                    Image("logoB&N")
                        .resizable()
                        .frame(width: 44, height: 35)
                        .padding(.leading)

                    Spacer()

                    Image(systemName: "bell")
                        .padding(.trailing)

                    if userSessionManager.puedeRegistrarAnuncio() {
                        Button(action: {
                            showAddAnuncioView = true
                        }, label: {
                            Image(systemName: "plus")
                                .padding(.trailing)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()

                Text("Anuncios")
                    .font(.title3)
                    .bold()
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.anuncios) { anuncio in
                            VStack(alignment: .leading, spacing: 0) {
                                // Imagen o espacio reservado
                                if let imageUrlString = anuncio.imagen, let imageUrl = URL(string: imageUrlString) {
                                    AsyncImage(url: imageUrl) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 150) // Altura fija para la imagen
                                                .clipped()
                                                .cornerRadius(10, corners: [.topLeft, .topRight])
                                        } else if phase.error != nil {
                                            Color.gray
                                                .frame(height: 150)
                                                .cornerRadius(10, corners: [.topLeft, .topRight])
                                        } else {
                                            ProgressView()
                                                .frame(height: 150)
                                        }
                                    }
                                } else {
                                    // Espacio reservado para tarjetas sin imagen
                                    Color.clear
                                        .frame(height: 150) // Misma altura que la imagen
                                }

                                // Título y contenido
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(anuncio.titulo)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)

                                    Text(anuncio.contenido)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(3)
                                        .minimumScaleFactor(0.8)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)

                                Spacer() // Ocupa el espacio restante
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 300) // Altura fija para todas las tarjetas
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                            // Acciones de contexto
                            .contextMenu {
                                if userSessionManager.puedeModificarAnuncio() {
                                    Button(action: {
                                        selectedAnuncio = anuncio
                                        showModifyView = true
                                    }, label: {
                                        Label("Modificar", systemImage: "pencil")
                                    })
                                }
                                if userSessionManager.puedeEliminarAnuncio() {
                                    Button(role: .destructive, action: {
                                        selectedAnuncio = anuncio
                                        showDeleteConfirmation = true
                                    }, label: {
                                        Label("Eliminar", systemImage: "trash")
                                    })
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .onAppear {
            Task {
                await viewModel.fetchAnuncios()
            }
        }
        .sheet(isPresented: $showAddAnuncioView) {
            AnadirAnuncioView(viewModel: viewModel)
        }
        .sheet(isPresented: Binding(
            get: { selectedAnuncio != nil && showModifyView },
            set: { newValue in
                if !newValue { selectedAnuncio = nil }
                showModifyView = newValue
            })) {
                if let anuncio = selectedAnuncio {
                    ModificarAnuncioView(viewModel: viewModel, anuncio: anuncio)
                }
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("¿Seguro quieres eliminar el anuncio?"),
                message: Text("Una vez eliminado no se podrá recuperar."),
                primaryButton: .destructive(Text("Eliminar")) {
                    if let anuncio = selectedAnuncio {
                        Task {
                            await viewModel.eliminarAnuncio(idAnuncio: anuncio.id)
                        }
                    }
                },
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
    }
}

// Extensión para aplicar esquinas específicas en cornerRadius
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

// Estructura auxiliar para esquinas específicas
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
