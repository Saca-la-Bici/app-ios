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
            VStack {
                ZStack {
                    HStack {
                        Image("logoB&N")
                            .resizable()
                            .frame(width: 44, height: 35)
                            .padding(.leading)

                        Spacer()

                        Image(systemName: "gear")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .onTapGesture {
                                Task {
                                    path.append(.configuration)
                                    restablecerContraseñaViewModel.esUsuarioConEmailPassword()
                                }
                            }
                        
                    }
                    .padding()

                    Text("Perfil")
                        .font(.title3)
                        .bold()
                }
                
                ScrollView {
                    
                    Spacer().frame(height: 10)
                    
                    // Imagen de perfil con borde de color
                    VStack {
                        HStack {
                            // Elementos invisibles para alinear el contenido
                            HStack(spacing: 3) {
                                Image("BloodDrop")
                                    .resizable()
                                    .frame(width: 18, height: 20)
                                    .padding(.top, 30)
                                    .opacity(0)
                                Text(consultarPerfilPropioViewModel.profile?.tipoSangre ?? "")
                                    .font(.subheadline)
                                    .padding(.top, 30)
                                    .opacity(0)
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
                    }
                    .padding(.bottom, 10)
                    
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
                        Button {
                            // Acción para Editar perfil
                        } label: {
                            Text("Editar perfil")
                                .font(.system(size: 14))
                                .padding(.all, 7)
                                .frame(width: 120)
                                .background(Color(red: 243/255, green: 240/255, blue: 235/255))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .shadow(radius: 5, y: 3)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button {
                            // Acción para Compartir perfil
                        } label: {
                            Text("Compartir perfil")
                                .font(.system(size: 14))
                                .padding(.all, 7)
                                .frame(width: 140)
                                .background(Color(red: 243/255, green: 240/255, blue: 235/255))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .shadow(radius: 5, y: 3)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button {
                            // Acción para agregar amigo
                        } label: {
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
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 10)
                    
                    IconSelectionView()
                }
            }
            .onAppear {
                Task {
                    try await
                    consultarPerfilPropioViewModel.consultarPerfilPropio()
                }
            }
            .alert(isPresented: .constant(consultarPerfilPropioViewModel.errorMessage != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(consultarPerfilPropioViewModel.errorMessage ?? "Hubo un error al ingresar a tu perfil, intente de nuevo más tarde"),
                    dismissButton: .default(Text("Aceptar"), action: {
                        consultarPerfilPropioViewModel.errorMessage = nil
                    })
                )
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
