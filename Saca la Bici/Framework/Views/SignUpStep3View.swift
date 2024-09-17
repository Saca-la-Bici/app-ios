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
        ScrollView {
            ZStack {
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
                
                        VStack(alignment: .leading) {
                            Text("Contraseña")
                                .font(.caption)
                            ZStack {
                                if signUpViewModel.isPasswordVisible {
                                    TextField("Contraseña", text: $signUpViewModel.password)
                                        .textInputAutocapitalization(.never)
                                } else {
                                    SecureField("Contraseña", text: $signUpViewModel.password)
                                        .textInputAutocapitalization(.never)
                                }
                            }
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .overlay(
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        signUpViewModel.isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: signUpViewModel.isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            )
                            
                            Spacer().frame(height: 20)
                            
                            Text("Confirmar contraseña")
                                .font(.caption)
                            ZStack {
                                if signUpViewModel.isConfirmVisible {
                                    TextField("Contraseña", text: $signUpViewModel.confirmPassword)
                                        .textInputAutocapitalization(.never)
                                } else {
                                    SecureField("Contraseña", text: $signUpViewModel.confirmPassword)
                                        .textInputAutocapitalization(.never)
                                }
                            }
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            signUpViewModel.isConfirmVisible.toggle()
                                        }) {
                                            Image(systemName: signUpViewModel.isConfirmVisible ? "eye.slash" : "eye")
                                                .foregroundColor(.gray)
                                                .padding()
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                )
                        }
                        
                        Spacer().frame(height: 30)
                        
                        Button {
                            Task {
                                await signUpViewModel.registrarUsuario()
                               // El listener se encarga automaticamente
                            }
                             
                        } label: {
                            Text("Continuar")
                                .font(.subheadline)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.black)
                                .background(Color(red: 0.961, green: 0.802, blue: 0.048))
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    
                    Spacer()
                }
                .padding(30)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .zIndex(2)
            }
            .alert(isPresented: $signUpViewModel.showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text(signUpViewModel.messageAlert)
                )
            }
        }
    }
}

