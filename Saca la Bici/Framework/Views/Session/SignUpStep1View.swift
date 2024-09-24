//
//  SignInStep1View.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import SwiftUI

struct SignUpStep1View: View {
    @Binding var path: [SessionPaths]
    
    @ObservedObject var signUpViewModel = SignUpViewModel()
    
    var body: some View {
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
            
            // Contenido del formulario
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer().frame(height: 30)
                    
                    // Título
                    TituloComponent(title: "Crear cuenta", imageName: "Bici", separatorBool: false)
                    
                    Spacer().frame(height: 50)
                    
                    // Formulario
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Correo electrónico
                        EmailField(email: $signUpViewModel.email,
                                   text: "Correo electrónico",
                                   placeholder: "Escribe tu correo electrónico...")
                        
                        // Nombre de usuario
                        TextoLimiteField(
                            label: "Nombre de usuario",
                            placeholder: "Escribe tu nombre de usuario...",
                            text: $signUpViewModel.username,
                            maxLength: 50,
                            title: false
                        )
                        
                        Spacer().frame(height: 0)
                        
                        // Fecha de nacimiento
                        FechaNacimientoPicker(
                            fechaSeleccion: $signUpViewModel.fechaNacimiento
                        )
                        
                        Spacer().frame(height: 10)
                        
                        // Botón de continuar
                        CustomButton(
                            text: "Continuar",
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            action: {
                                Task {
                                    await signUpViewModel.validarDatosStep1()
                                    if !signUpViewModel.showAlert {
                                        path.append(.continueRegistration)
                                    }
                                }
                            }
                        )
                    }
                    
                    Spacer()
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
        }
    }
}

struct SignInStep1View_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [SessionPaths] = []

        var body: some View {
            SignUpStep1View(path: $path)
        }
    }
}
