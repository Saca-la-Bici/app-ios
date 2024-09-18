//
//  SignUpStep3View.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import SwiftUI

struct SignUpStep3View: View {
    @Binding var path: [String]
    
    @ObservedObject var signUpViewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
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
                    HStack(alignment: .center, spacing: 15) {
                        Text("Crear cuenta")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("_______")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.961, green: 0.802, blue: 0.048))
                        Image("Bici")
                            .resizable()
                            .frame(width: 40, height: 24)
                    }
                    
                    Spacer().frame(height: 30)
                    
                    // Formulario
                    VStack(alignment: .leading,spacing: 20) {
                        
                        PasswordField(
                            password: $signUpViewModel.password,
                            isPasswordVisible: $signUpViewModel.isPasswordVisible,
                            text: "Contraseña"
                        )
                        
                        PasswordField(
                            password: $signUpViewModel.confirmPassword,
                            isPasswordVisible: $signUpViewModel.isConfirmVisible,
                            text: "Confirmar Contraseña"
                        )
                        
                        Spacer().frame(height: 30)
                        
                        CustomButton(
                            text: "Continuar",
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            action: {
                                Task {
                                    await signUpViewModel.registrarUsuario()
                                   // El listener se encarga automaticamente
                                }
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(30)
            }
            .zIndex(2)
            .alert(isPresented: $signUpViewModel.showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text(signUpViewModel.messageAlert)
                )
            }
        }
    }
}
