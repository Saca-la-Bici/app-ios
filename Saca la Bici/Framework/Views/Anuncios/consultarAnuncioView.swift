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
    @State private var isLoading = true

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
            } else if isLoading {
                ProgressView("Cargando anuncios...")
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if viewModel.anuncios.isEmpty {
                Text("No hay anuncios")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.anuncios) { anuncio in
                            VStack(alignment: .leading, spacing: 0) {
                                if let imageUrlString = anuncio.imagen, let imageUrl = URL(string: imageUrlString) {
                                    AsyncImage(url: imageUrl) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(maxWidth: .infinity)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(10, corners: [.topLeft, .topRight])
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                                .clipped()
                                                .cornerRadius(10, corners: [.topLeft, .topRight])
                                        case .failure:
                                            VStack {
                                                Image(systemName: "exclamationmark.triangle")
                                                    .foregroundColor(.red)
                                                    .font(.largeTitle)
                                                Text("Error cargando imagen")
                                                    .foregroundColor(.red)
                                                    .font(.caption)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(10, corners: [.topLeft, .topRight])
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(anuncio.titulo)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    Text(anuncio.contenido)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .minimumScaleFactor(0.8)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)

                                Spacer()
                            }
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
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
                isLoading = true
                await viewModel.fetchAnuncios()
                isLoading = false
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
        clipShape(RoundedCorner(radius: radius, corners: corners))
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
