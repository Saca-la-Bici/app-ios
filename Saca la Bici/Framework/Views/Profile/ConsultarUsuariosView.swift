//
//  ConsultarUsuariosView.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 05/10/24.
//

import SwiftUI

struct ConsultarUsuariosView: View {
    @StateObject private var viewModel = ConsultarUsuariosViewModel()
    @State private var searchText: String = ""
    @State private var selectedTab: Tab = .administradores
    @State private var searchTimer: Timer?

    // Binding
    @Binding var path: [ConfigurationPaths]

    enum Tab: String, CaseIterable, Identifiable {
        case administradores = "Administradores"
        case staff = "Staff"

        var id: String { self.rawValue }
    }

    var body: some View {
        ZStack {
            VStack {
                // Picker
                Picker("Seleccione un rol", selection: $selectedTab) {
                    ForEach(Tab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedTab) {
                    viewModel.isLoading = true
                    if searchText.isEmpty {
                        viewModel.resetPagination()
                        viewModel.cargarUsuarios(roles: selectedRoles)
                    } else {
                        viewModel.resetPagination()
                        viewModel.buscadorUsuarios(roles: selectedRoles, search: searchText)
                    }
                }
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Buscar", text: $searchText)
                        .padding(.leading, 10)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding([.leading, .trailing])
                .onChange(of: searchText) { _, newValue in
                    viewModel.isLoading = true
                    searchTimer?.invalidate()
                    searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        Task {
                            if newValue.isEmpty {
                                await viewModel.resetPagination()
                                await viewModel.cargarUsuarios(roles: selectedRoles)
                            } else {
                                await viewModel.resetPagination()
                                await viewModel.buscadorUsuarios(roles: selectedRoles, search: newValue)
                            }
                        }
                    }
                    
                }
                // Condicion por si no hay usuarios
                if viewModel.usuarios.isEmpty && !viewModel.isLoading {
                    Spacer()
                    Text("No se encontro a ningún usuario.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    // User List
                    List {
                        ForEach(viewModel.usuarios) { usuario in
                            HStack {
                                // Imagen de perfil
                                if let imagenPerfil = usuario.usuario.imagenPerfil, let url = URL(string: imagenPerfil) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                                
                                // Información del usuario
                                VStack(alignment: .leading) {
                                    Text(usuario.usuario.username)
                                        .font(.headline)
                                    Text(usuario.usuario.correoElectronico)
                                        .font(.subheadline)
                                }
                                Spacer()
                                
                                // Botón
                                Button(action: {
                                    Task {
                                        var idNuevoRol: String?
                                        for rol in viewModel.roles {
                                            if usuario.rol.nombreRol == "Administrador" && rol.nombre == "Usuario" {
                                                idNuevoRol = rol._id
                                                break
                                            } else if usuario.rol.nombreRol == "Staff" && rol.nombre == "Usuario" {
                                                idNuevoRol = rol._id
                                                break
                                            } else if usuario.rol.nombreRol == "Usuario" {
                                                if selectedTab == .administradores && rol.nombre == "Administrador" {
                                                    idNuevoRol = rol._id
                                                    break
                                                } else if selectedTab == .staff && rol.nombre == "Staff" {
                                                    idNuevoRol = rol._id
                                                    break
                                                }
                                            }
                                        }
                                        
                                        if let idRol = idNuevoRol {
                                            await viewModel.modifyRole(idRol: idRol, idUsuario: usuario.id)
                                        } else {
                                            print("No se encontró un rol válido.")
                                        }
                                    }
                                }, label: {
                                    Text((usuario.rol.nombreRol == "Administrador" || usuario.rol.nombreRol == "Staff")
                                         ? "Eliminar"
                                         : "Agregar")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        (usuario.rol.nombreRol == "Administrador" || usuario.rol.nombreRol == "Staff")
                                        ? Color.gray
                                        : Color.yellow
                                    )
                                    .cornerRadius(10)
                                })
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onAppear {
                                if searchText.isEmpty && usuario == viewModel.usuarios.last {
                                    viewModel.isLoading = true
                                    viewModel.cargarUsuarios(roles: selectedRoles)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                // Progress View
                if viewModel.isLoading {
                    ProgressView("Cargando usuarios")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }
            .navigationTitle("Asignación de roles y permisos")
            .onAppear {
                viewModel.isLoading = true
                viewModel.cargarUsuarios(roles: selectedRoles)
                Task {
                    await viewModel.getRoles()
                }
            }
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = true
            }
            .alert(item: $viewModel.activeAlert) { alertType in
                switch alertType {
                case .error:
                    return Alert(
                        title: Text("Oops!"),
                        message: Text(viewModel.alertMessage ?? "Error desconocido.")
                    )
                case .errorConsultar:
                    return Alert(
                        title: Text("Oops!"),
                        message: Text(viewModel.alertMessage ?? "Error desconocido."),
                        dismissButton: .default(Text("OK")) {
                            path.removeLast()
                        }
                    )
                case .success:
                    return Alert(
                        title: Text("Éxito"),
                        message: Text(viewModel.alertMessage ?? "El rol del usuario ha sido modificado correctamente."),
                        dismissButton: .default(Text("OK")) {
                            viewModel.resetPagination()
                            viewModel.cargarUsuarios(roles: selectedRoles)
                        }
                    )
                }
            }
        }
    }

    private var selectedRoles: [String] {
        switch selectedTab {
        case .administradores:
            return ["Administrador", "Usuario"]
        case .staff:
            return ["Staff", "Usuario"]
        }
    }

    // Filtro para buscar
    var filteredUsers: [ConsultarUsuario] {
        return viewModel.usuarios
    }
}
