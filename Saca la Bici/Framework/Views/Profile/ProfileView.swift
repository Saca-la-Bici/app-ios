//
//  ProfileView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 26/09/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var path: [ConfigurationPaths] = []
    
    @StateObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    @StateObject private var consultarPerfilPropioViewModel = ConsultarPerfilPropioViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 10) {
                        // Parte superior: Nombre de usuario y iconos
                        HStack {
                            Text(consultarPerfilPropioViewModel.profile?.username ?? "")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Spacer()
                            HStack(spacing: 15) {
                                Button(action: {
                                    Task {
                                        path.append(.configuration)
                                        restablecerContraseñaViewModel.esUsuarioConEmailPassword()
                                    }
                                }) {
                                    Image("Campanita")
                                }
                                Button(action: {
                                    Task {
                                        path.append(.configuration)
                                        restablecerContraseñaViewModel.esUsuarioConEmailPassword()
                                    }
                                }) {
                                    Image("Engranaje")
                                }
                                
                            }
                            .font(.title3)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)

                        // Imagen de perfil con borde de color
                        VStack {
                            HStack {
                                // Elementos invisibles para alinear el contenido
                                HStack(spacing: 3) {
                                    Image("BloodDrop")
                                        .resizable()
                                        .frame(width: 18, height: 20)
                                        .padding(.top, 30)
                                        .opacity(0)  // Hacerlo invisible, pero sigue ocupando espacio

                                    Text(consultarPerfilPropioViewModel.profile?.tipoSangre ?? "")
                                        .font(.subheadline)
                                        .padding(.top, 30)
                                        .opacity(0)  // Hacerlo invisible, pero sigue ocupando espacio
                                }

                                // Imagen centrada
                                Image("")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                
                                // Elementos visibles
                                HStack(spacing: 3) {
                                    Image("BloodDrop")
                                        .resizable()
                                        .frame(width: 18, height: 20)
                                        .padding(.top, 50)
                                    
                                    Text(consultarPerfilPropioViewModel.profile?.tipoSangre ?? "")
                                        .font(.subheadline)
                                        .padding(.top, 50)
                                }
                            }
                            .frame(maxWidth: .infinity)

                                Text(consultarPerfilPropioViewModel.profile?.nombre ?? "")
                                    .font(.subheadline)
                            
                        }.padding(.bottom, 10)

                        // Estadísticas de usuario: Rodadas, Kilómetros, Amigos
                        HStack {
                            VStack(spacing: 10) {
                                Text("\(consultarPerfilPropioViewModel.profile?.rodadasCompletadas ?? 1)")
                                    .font(.system(size: 12))
                                Text("Rodadas")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            VStack(spacing: 10) {
                                Text("\(String(format: "%.1f", consultarPerfilPropioViewModel.profile?.kilometrosRecorridos ?? 5))km")
                                    .font(.system(size: 12))
                                Text("Kilómetros")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            VStack(spacing: 10) {
                                Text("1234")
                                    .font(.system(size: 12))
                                Text("Amigos")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.horizontal, 72)
                        .padding(.bottom, 10)
                        
                        HStack {
                            Button(action: {
                                // Acción para Editar perfil
                            }) {
                                Text("Editar perfil")
                                    .font(.system(size: 14))
                                    .padding(.all, 7)
                                    .frame(width: 120)
                                    .background(Color(red: 243/255, green: 240/255, blue: 235/255))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .shadow(radius: 5, y: 3)
                            }
                            
                            Button(action: {
                                // Acción para Compartir perfil
                            }) {
                                Text("Compartir perfil")
                                    .font(.system(size: 14))
                                    .padding(.all, 7)
                                    .frame(width: 140)
                                    .background(Color(red: 243/255, green: 240/255, blue: 235/255))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .shadow(radius: 5, y: 3)
                            }

                            Button(action: {
                                // Acción para agregar amigo
                            }) {
                                Image("AgregarAmigo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(.all, 7)
                                    .background(Color(red: 243/255, green: 240/255, blue: 235/255))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .shadow(radius: 5, y: 3)
                            }
                        }.padding(.bottom, 20)
                        
                        IconSelectionView()
                        
                       // Spacer()  // Esto empuja todo hacia arriba
                    }
                    .padding()
                    .onAppear {
                        Task {
                            try await consultarPerfilPropioViewModel.consultarPerfilPropio()
                        }
                    }
            .navigationDestination(for: ConfigurationPaths.self) { value in
                switch value {
                case .faqs:
                    FAQView(path: $path)
                case .faqDetail(let faq, let permisos):
                    FAQDetailView(faq: faq, permisos: permisos, path: $path)
                case .addFAQ:
                    AddFAQView(path: $path)
                case .updateFAQ(let faq):
                    UpdateFAQView(faq: faq, path: $path)
                case .configuration:
                    ConfigurationView(restablecerContraseñaViewModel: restablecerContraseñaViewModel, path: $path)
                case .profile:
                    SeguridadAccesoView(restablecerContraseñaViewModel: restablecerContraseñaViewModel, path: $path)
                case .password:
                    RestablecerContrasenaView(path: $path)
                case .olvidar:
                    PasswordRecoveryView<ConfigurationPaths>(path: $path, showIniciarSesion: false )
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
