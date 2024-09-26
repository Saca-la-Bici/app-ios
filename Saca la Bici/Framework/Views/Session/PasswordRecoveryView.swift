//
//  OlvidasteContraseñaView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 25/09/24.
//

import SwiftUI

struct PasswordRecoveryView: View {
    @Binding var path: [SessionPaths]
    @StateObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    
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
                    
                    TituloComponent(title: "Recupera tu contraseña", imageName: "Bici", separatorBool: false)
                    
                    Spacer().frame(height: 50)
                    
                    // Mensaje
                    Text("Entendemos que estas cosas pasan. Enviaremos un enlace de recuperación a tu correo. No te preocupes.")
                        .font(.caption)
                    
                    Spacer().frame(height: 30)
                    
                    // Formulario
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Correo electrónico
                        VStack(alignment: .leading) {
                            EmailField(email: $restablecerContraseñaViewModel.emailOrUsername,
                                       text: "Correo electrónico o usuario",
                                       placeholder: "Escribe tu correo o usuario...")
                        }
                        
                        CustomButton(
                            text: restablecerContraseñaViewModel.buttonLabel,
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            action: {
                                Task {
                                    await restablecerContraseñaViewModel.emailRestablecerContraseña()
                                }
                            }
                        )
                        
                        // Mensaje
                        HStack {
                            Text("¿Ya tienes una cuenta?")
                                .font(.caption)
                            
                            Button(action: {
                                path.removeLast()
                            }, label: {
                                Text("Inicia sesión aquí")
                                    .font(.caption)
                                    .underline()
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    
                    Spacer()
                }
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .alert(isPresented: $restablecerContraseñaViewModel.showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text(restablecerContraseñaViewModel.messageAlert)
                )
            }
            .padding(30)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            .zIndex(2)
        }
        
    }
}

struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [SessionPaths] = []

        var body: some View {
            PasswordRecoveryView(path: $path)
        }
    }
}
