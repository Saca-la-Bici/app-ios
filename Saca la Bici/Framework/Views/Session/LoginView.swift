//
//  ContentView.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 04/09/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var path: [SessionPaths]
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            // Fondo amarillo
            VStack {
                Spacer()
                ImagenAmarillaFondo()
                    .fill(Color.yellow)
                    .frame(height: 250)
                    .overlay(
                        ImagenAmarillaFondo()
                            .stroke(Color.black, lineWidth: 2)
                            .offset(y: -10)
                            .offset(x: 30)
                    )
                    .offset(y: 50)
            }
            .ignoresSafeArea()
            .zIndex(1)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 30)
                    
                    // Título
                    TituloComponent(title: "Inicia Sesión", imageName: "Bici", separatorBool: false)
                    
                    Spacer().frame(height: 50)
                    
                    // Formulario
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Correo electrónico
                        EmailField(email: $loginViewModel.emailOrUsername,
                                   text: "Correo electrónico o usuario",
                                   placeholder: "Escribe tu correo o usuario...")
                        
                        // Contraseña
                        PasswordField(
                            password: $loginViewModel.password,
                            isPasswordVisible: $loginViewModel.isPasswordVisible,
                            text: "Contraseña"
                        )
                        
                        // ¿Olvidaste tu contraseña?
                        Button(action: {
                            path.append(.olvidar)
                        }, label: {
                            Text("¿Olvidaste tu contraseña?")
                                .font(.caption)
                                .underline()
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        CustomButton(
                            text: "Iniciar Sesión",
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            action: {
                                Task {
                                    await loginViewModel.iniciarSesion()
                                    
                                    // Cambiar el estado de autenticación para loggear al usuario
                                    if loginViewModel.showAlert != true {
                                        sessionManager.isAuthenticated = true
                                        sessionManager.isProfileComplete = true
                                        UserDefaults.standard.set(true, forKey: "isRegistrationComplete")
                                    } else {
                                        UserDefaults.standard.set(false, forKey: "isRegistrationComplete")
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(30)
                .alert(isPresented: $loginViewModel.showAlert) {
                    Alert(
                        title: Text("Oops!"),
                        message: Text(loginViewModel.messageAlert)
                    )
                }
            }
            .zIndex(2)
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [SessionPaths] = []

        var body: some View {
            LoginView(path: $path)
        }
    }
}
