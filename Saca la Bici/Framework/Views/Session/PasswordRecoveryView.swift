//
//  OlvidasteContraseñaView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 25/09/24.
//

import SwiftUI

struct PasswordRecoveryView<PathType: Equatable>: View {
    @Binding var path: [PathType]
    
    @StateObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    
    var showIniciarSesion: Bool
    
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
                        
                        if showIniciarSesion {
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
                        
                    }
                }
                .padding(30)
                .alert(isPresented: $restablecerContraseñaViewModel.showAlert) {
                    if restablecerContraseñaViewModel.alertSuccess == true {
                        return Alert(
                            title: Text("¡Éxito!"),
                            message: Text(restablecerContraseñaViewModel.messageAlert),
                            dismissButton: .default(Text("OK")) {
                                path.removeLast()
                            }
                        )
                    } else {
                        return Alert(
                            title: Text("Oops!"),
                            message: Text(restablecerContraseñaViewModel.messageAlert),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .zIndex(2)
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
        }
    }
}

struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [SessionPaths] = []
        
        var showIniciarSesion: Bool = true

        var body: some View {
            PasswordRecoveryView(path: $path, showIniciarSesion: true)
        }
    }
}
