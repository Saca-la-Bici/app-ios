//
//  ModificarPerfilView.swift
//  Saca la Bici
//
//  Created by Diego Lira on 09/10/24.
//

import SwiftUI

struct ModificarPerfilView: View {
    
    @StateObject private var consultarPerfilPropioViewModel = ConsultarPerfilPropioViewModel.shared
    @StateObject private var modificarPerfilViewModel = ModificarPerfilViewModel()

    @State private var nombre: String
    @State private var nombreUsuario: String
    @State private var tipoSangre: String
    @State private var telefonoEmergencia: String = ""
    @State private var resultado: String = ""
    @State private var mostrarAlerta: Bool = false
    
    let tiposSangre = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-", "No seleccionado"]
    
    init() {
            // Inicializando los valores con el singleton de Profile
            let profile = ConsultarPerfilPropioViewModel.shared.profile
            
            _nombre = State(initialValue: profile?.nombre ?? "")
            _nombreUsuario = State(initialValue: profile?.username ?? "")
            _tipoSangre = State(initialValue: profile?.tipoSangre ?? "Sin seleccionar")
            _telefonoEmergencia = State(initialValue: profile?.numeroEmergencia ?? "")
        }
    
    var body: some View {
            VStack {
                // Parte superior fija
                VStack {
                    // Imagen de perfil
                    if let imageUrlString = consultarPerfilPropioViewModel.profile?.imagen, let imageUrl = URL(string: imageUrlString) {
                        AsyncImage(url: imageUrl) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 80, height: 80)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            case .failure:
                                Image(systemName: "person.crop.circle.badge.exclamationmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.gray)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                    }
                    
                    // Botón para editar la foto
                    Text("Editar foto")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding(.top, 5)
                }
                .padding(.top, 20)
                
                // ScrollView para los campos de texto
                ScrollView {
                    VStack(spacing: 15) {
                        TextoLimiteField(label: "Nombre", placeholder: "Nombre", text: $nombre, maxLength: 30)
                        TextoLimiteField(label: "Nombre de usuario", placeholder: "Nombre de usuario", text: $nombreUsuario, maxLength: 20)
                        TextoLimiteField(label: "Número de Emergencia", placeholder: "Teléfono", text: $telefonoEmergencia, maxLength: 15)
                        DropdownField(label: "Tipo de sangre", options: tiposSangre, selectedOption: $tipoSangre)
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity)
                .navigationTitle("Editar Perfil")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            Task {
                                // Llama la función asincrónica y guarda el resultado concatenado
                                resultado = await modificarPerfilViewModel.modificarPerfil(
                                    nombre: nombre,
                                    username: nombreUsuario,
                                    tipoSangre: tipoSangre,
                                    numeroEmergencia: telefonoEmergencia
                                )
                                
                                mostrarAlerta = true
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .alert("Resultado", isPresented: $mostrarAlerta) {
                    Button("Aceptar", role: .cancel) {}
                } message: {
                    Text(resultado)
                }
            }
        }
    }
