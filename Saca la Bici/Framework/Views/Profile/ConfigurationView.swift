//
//  ConfiguracionView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 26/09/24.
//

import SwiftUI

struct ConfigurationView: View {
    // Para manejar las sesiones
    @EnvironmentObject var sessionManager: SessionManager
    
    @ObservedObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    @ObservedObject private var userSessionManager = UserSessionManager.shared
    
    @Binding var path: [ConfigurationPaths]
    
    @State private var safariURL: URL?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Spacer()
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Más información y asistencia")
                            .foregroundColor(.gray)
                            .font(.callout)
                            .bold()
                            .padding(.leading, 20)
                        
                        Group {
                            BotonSection(icono: "questionmark.circle", titulo: "Ayuda",
                                         button: true,
                                         path: $path,
                                         nextPath: .faqs)
                            BotonSection(icono: "info.circle", titulo: "Información",
                                         button: true,
                                         path: $path,
                                         nextPath: .informacion)
                            BotonSection(icono: "figure.outdoor.cycle", titulo: "Cómo usar la app",
                                         button: true,
                                         path: $path,
                                         nextPath: .faqs)
                            
                            if userSessionManager.puedeModificarRol() {
                                BotonSection(icono: "person.badge.plus",
                                             titulo: "Asignación de Roles y Permisos",
                                             button: true,
                                             path: $path,
                                             nextPath: .asignacionRoles)
                            }
                            
                            if userSessionManager.puedeDesactivarUsuario() {
                                BotonSection(icono: "person.crop.circle.badge.minus",
                                             titulo: "Desactivar Usuarios",
                                             button: true,
                                             path: $path,
                                             nextPath: .desactivarUsuarios)
                            }
                        }
                    }
                    .padding(.horizontal, 25)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Administra tu cuenta")
                            .foregroundColor(.gray)
                            .font(.callout)
                            .bold()
                            .padding(.leading, 20)
                        
                        BotonSection(icono: "person.circle", titulo: "Tu Cuenta",
                                     button: true,
                                     path: $path,
                                     nextPath: .profile)
                    }
                    .padding(.horizontal, 25)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Otras plataformas")
                            .foregroundColor(.gray)
                            .font(.callout)
                            .bold()
                            .padding(.leading, 20)
                        
                        Button(action: {
                            safariURL = URL(string: "http://sacalabici.org")
                        }, label: {
                            HStack {
                                Image(systemName: "globe")
                                Text("Saca la Bici")
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            safariURL = URL(string: "http://rentabici.sacalabici.org")
                        }, label: {
                            HStack {
                                Image(systemName: "globe")
                                Text("Rentabici")
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 25)
                    
                    Divider()
                    
                    HStack {
                        Button {
                            Task {
                                await sessionManager.signOut()
                            }
                        } label: {
                            Text("Cerrar Sesión")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }
                    .padding(.horizontal, 25)
                }
            }
        }
        .navigationTitle("Configuración y Privacidad")
        .padding(.top, 4)
        .sheet(item: $safariURL) { url in
            SafariView(url: url)
        }
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ConfigurationPaths] = []

        var body: some View {
            ConfigurationView(path: $path)
        }
    }
}
