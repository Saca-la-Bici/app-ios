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
                        // Aquí puedes agregar la acción para la recuperación de contraseña
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
                                // El listener se encarga del menu
                            }
                        }
                    )
                    
                    // O continúa con
                    Text("o continúa con")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity)
                    
                    ExternalLoginButton(
                        action: {
                            await loginViewModel.GoogleLogin()
                            // El listener se encarga del menu
                        },
                        buttonText: "Continuar con Google",
                        imageName: "GoogleLogo",
                        systemImage: false 
                    )
                    
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


