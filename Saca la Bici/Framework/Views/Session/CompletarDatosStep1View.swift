//
//  CompletarDatos.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct CompletarDatosStep1View: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var signUpViewModel = SignUpViewModel()
    @State private var path: [SessionPaths] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack {
                    Spacer()
                    ImagenAmarillaFondo()
                        .fill(Color.yellow)
                        .frame(height: 200)
                        .overlay(
                            ImagenAmarillaFondo()
                                .stroke(Color.black, lineWidth: 2)
                                .offset(y: -10)
                                .offset(x: 30)
                        )
                        .offset(y: 80)
                }
                .ignoresSafeArea()
                .zIndex(1)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Botón para continuar con otra cuenta en la esquina derecha superior
                        HStack {
                            Button(action: {
                                Task {
                                    await sessionManager.signOut()
                                }
                            }, label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
                            })
                        }
                        .padding(.top, -10)
                        
                        // Título
                        TituloComponent(title: "Completar Registro", separator: "_", imageName: "Bici", separatorBool: true)
                        
                        Spacer().frame(height: 30)
                        
                        // Formulario Paso 1
                        VStack(alignment: .leading, spacing: 20) {
                            
                            TextoLimiteField(
                                label: "Nombre de usuario",
                                placeholder: "Escribe tu nombre de usuario",
                                text: $signUpViewModel.username,
                                maxLength: 50,
                                title: true
                            )
                            
                            Spacer().frame(height: 5)
                            
                            // Fecha de nacimiento
                            FechaNacimientoPicker(
                                fechaSeleccion: $signUpViewModel.fechaNacimiento
                            )
                        }
                        
                        Spacer().frame(height: 30)
                        
                        CustomButton(
                            text: "Continuar",
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            action: {
                                Task {
                                    await signUpViewModel.validarCompletarDatos1()
                                    if !signUpViewModel.showAlert {
                                        path.append(.completarDatos)
                                    }
                                }
                            }
                        )
                        
                        Spacer().frame(height: 0)
                    }
                    .padding(30)
                }
                .zIndex(2)
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
                .alert(isPresented: $signUpViewModel.showAlert) {
                    Alert(
                        title: Text("Oops!"),
                        message: Text(signUpViewModel.messageAlert)
                    )
                }
                .navigationDestination(for: SessionPaths.self) { value in
                    switch value {
                    case .completarDatos:
                        CompletarDatosStep2View(path: $path, signUpViewModel: signUpViewModel)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .onAppear {
            // Configurar el closure para actualizar el SessionManager
            signUpViewModel.onProfileComplete = {
                sessionManager.actualizarEstadoPerfilCompleto(true)
            }
        }
    }
}
