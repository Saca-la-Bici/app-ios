//
//  ContentView.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 04/09/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                Spacer().frame(height: 30)
                
                // Título
                HStack(alignment: .center, spacing: 15) {
                    Text("Inicia Sesión")
                        .font(.title2)
                        .fontWeight(.bold)
                    Image(systemName: "bicycle")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Spacer().frame(height: 50)
                
                // Formulario
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Correo electrónico
                    VStack(alignment: .leading) {
                        Text("Correo electrónico o usuario")
                            .font(.caption)
                        TextField("Correo electrónico o usuario", text: $loginViewModel.emailOrUsername)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                    
                    // Contraseña
                    VStack(alignment: .leading) {
                        Text("Contraseña")
                            .font(.caption)
                        ZStack {
                            if loginViewModel.isPasswordVisible {
                                TextField("Contraseña", text: $loginViewModel.password)
                                    .textInputAutocapitalization(.never)
                            } else {
                                SecureField("Contraseña", text: $loginViewModel.password)
                                    .textInputAutocapitalization(.never)
                            }
                        }
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                Spacer()
                                Button(action: {
                                    loginViewModel.isPasswordVisible.toggle() // Muestra u oculta la contraseña
                                }) {
                                    Image(systemName: loginViewModel.isPasswordVisible ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                        .padding()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    }
                    
                    // ¿Olvidaste tu contraseña?
                    Button(action: {
                        // Aquí puedes agregar la acción para la recuperación de contraseña
                    }, label: {
                        Text("¿Olvidaste tu contraseña?")
                            .font(.caption)
                            .underline()
                    })
                    .buttonStyle(PlainButtonStyle())
                    
                    // Iniciar sesión
                    Button {
                        Task {
                            await loginViewModel.iniciarSesion()
                            // El listener se encarga del menu
                        }
                        
                    } label: {
                        Text("Iniciar sesión")
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.black)
                            .background(Color(red: 0.961, green: 0.802, blue: 0.048))
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // O continúa con
                    Text("o continúa con")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        Task {
                            await loginViewModel.GoogleLogin()
                            // El listener se encarga del menu
                        }
                    }) {
                        HStack(alignment: .center, spacing: 15.0) {
                            Image("GoogleLogo")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                            Text("Continuar con Google")
                                .font(.subheadline)
                                .foregroundColor(Color.primary)
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


