//
//  OlvidasteContraseñaView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 25/09/24.
//

import SwiftUI

struct PasswordRecoveryView: View {
    @Binding var path: [SessionPaths]
    
    @State var emailOrUsername: String = ""
    @State var buttonLabel: String = "Enviar enlace"
    
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
                
                Spacer().frame(height: 30)
                
                TituloComponent(title: "Recupera tu contraseña", imageName: "Bici", separatorBool: false)
                
                Spacer().frame(height: 50)
                
                // Mensaje
                Text("Entendemos que estas cosas pasan. Enviaremos un enlace de recuperación a tu correo. Tú no te preocupes.")
                    .font(.caption)
                
                Spacer().frame(height: 30)
                
                // Formulario
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Correo electrónico
                    VStack(alignment: .leading) {
                        Text("Correo electrónico o usuario")
                            .font(.caption)
                        TextField("Correo electrónico o usuario", text: $emailOrUsername)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .padding()
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                    }
                    
                    Button {
                        buttonLabel = "¡Enlace enviado!"
                    } label: {
                        Text(buttonLabel)
                            .font(.subheadline)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.black)
                            .background(Color(red: 0.961, green: 0.802, blue: 0.048))
                            .cornerRadius(10)
                    }
                    
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
                    }
                    
                }
                
                Spacer()
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
