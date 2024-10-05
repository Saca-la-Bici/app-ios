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

    // Binding
    @Binding var path: [ConfigurationPaths]

    enum Tab: String, CaseIterable, Identifiable {
        case administradores = "Administradores"
        case staff = "Staff"

        var id: String { self.rawValue }
    }

    var body: some View {
        VStack {
            // Picker para seleccionar rol
            Picker("Seleccione un rol", selection: $selectedTab) {
                ForEach(Tab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onChange(of: selectedTab) { _ in
                viewModel.resetPagination()
                viewModel.cargarUsuarios(roles: selectedRoles)
            }

            // Barra para buscar
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Buscar", text: $searchText)
                    .padding(.leading, 10)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding([.leading, .trailing])

            // Lista de usuarios
            List {
                ForEach(filteredUsers) { usuario in
                    HStack {
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
                        VStack(alignment: .leading) {
                            Text(usuario.usuario.username)
                                .font(.headline)
                            Text(usuario.usuario.correoElectronico)
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            // Botones
                        }) {
                            Text((usuario.rol.nombreRol == "Administrador" || usuario.rol.nombreRol == "Staff") ? "Eliminar" : "Agregar")
                                .font(.body)
                                .foregroundColor(.white)
                                .padding()
                                .background((usuario.rol.nombreRol == "Administrador" || usuario.rol.nombreRol == "Staff") ? Color.gray : Color.yellow)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical, 8)
                }
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    Button("Cargar más") {
                        viewModel.cargarUsuarios(roles: selectedRoles)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Usuarios")
        .onAppear {
            viewModel.cargarUsuarios(roles: selectedRoles)
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
        if searchText.isEmpty {
            return viewModel.usuarios
        } else {
            return viewModel.usuarios.filter { $0.usuario.nombre.contains(searchText) }
        }
    }
}
