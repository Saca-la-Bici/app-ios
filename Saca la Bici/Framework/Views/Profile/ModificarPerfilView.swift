//
//  ModificarPerfilView.swift
//  Saca la Bici
//
//  Created by Diego Lira on 09/10/24.
//

import SwiftUI
import Combine

struct ModificarPerfilView: View {
    
    @StateObject private var consultarPerfilPropioViewModel = ConsultarPerfilPropioViewModel.shared
    @StateObject private var modificarPerfilViewModel = ModificarPerfilViewModel()
    @State var isLoading: Bool = false
    @Binding var path: [ConfigurationPaths]

    @State var nombre: String = ""
    @State var nombreUsuario: String = ""
    @State var tipoSangre: String = ""
    @State var telefonoEmergencia: String = ""
    @State var resultado: String = ""
    @State var mostrarAlerta: Bool = false
    
    let tiposSangre = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-", "Sin seleccionar"]
    
    var body: some View {
        VStack {
            profileHeader() // Encabezado del perfil
            formFields() // Campos del formulario
        }
        .onAppear {
            // Inicializa los valores del perfil al aparecer la vista
            let profile = consultarPerfilPropioViewModel.profile
            nombre = profile?.nombre ?? ""
            nombreUsuario = profile?.username ?? ""
            tipoSangre = profile?.tipoSangre ?? "Sin seleccionar"
            telefonoEmergencia = profile?.numeroEmergencia ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                saveButton() // Botón para guardar cambios
            }
        }
        .alert("Resultado", isPresented: $mostrarAlerta) {
            Button("Aceptar", role: .cancel) {
                path.removeLast() // Remueve el último path al confirmar
            }
        } message: {
            Text(resultado)
        }
    }

    @ViewBuilder
    private func profileHeader() -> some View {
        VStack {
            if let imageUrlString = consultarPerfilPropioViewModel.profile?.imagen,
               let imageUrl = URL(string: imageUrlString) {
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
                        profileImagePlaceholder() // Vista de imagen predeterminada en caso de error
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                profileImagePlaceholder() // Vista de imagen predeterminada cuando no hay imagen
            }

            Text("Editar foto")
                .font(.caption)
                .foregroundColor(.yellow)
                .padding(.top, 5)
        }
        .padding(.top, 20)
    }

    @ViewBuilder
    private func profileImagePlaceholder() -> some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
            .foregroundColor(.gray)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 1))
            .shadow(color: .gray, radius: 2, x: 2, y: 2)
    }

    @ViewBuilder
    private func formFields() -> some View {
        ScrollView {
            VStack(spacing: 15) {
                TextoLimiteField(label: "Nombre", placeholder: "Nombre", text: $nombre, maxLength: 30)
                TextoLimiteField(label: "Nombre de usuario", placeholder: "Nombre de usuario", text: $nombreUsuario, maxLength: 20)
                VStack(alignment: .leading) {
                    Text("Teléfono de Emergencia")
                        .font(.caption)
                    TextField("Teléfono de Emergencia", text: $telefonoEmergencia)
                        .keyboardType(.numberPad)
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .onReceive(Just(telefonoEmergencia)) { _ in
                            if telefonoEmergencia.count > 15 {
                                telefonoEmergencia = String(telefonoEmergencia.prefix(15))
                            }
                        }
                }
                
                TipoSangrePicker(selectedBloodType: $tipoSangre, bloodTypes: tiposSangre)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func saveButton() -> some View {
        Button {
            Task {
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
