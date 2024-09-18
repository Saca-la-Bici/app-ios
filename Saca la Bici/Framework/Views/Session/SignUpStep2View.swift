//
//  SignInStep2View.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import SwiftUI

struct SignUpStep2View: View {
    
    @Binding var path: [String]
    
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
            
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Spacer().frame(height: 30)
                    
                    // Título
                    TituloComponent(title: "Crear cuenta", separator: "___", imageName: "Bici", separatorBool: true)
                    
                    Spacer().frame(height: 30)
                    
                    // Formulario
                    VStack(alignment: .leading,spacing: 20) {
                        
                        // Contraseña
                        VStack(alignment: .leading) {
                            
                            Text("Información Adicional")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Spacer().frame(height: 20)
                            
                            TipoSangrePicker(
                                selectedBloodType: $signUpViewModel.selectedBloodType,
                                bloodTypes: signUpViewModel.bloodTypes
                            )
                            
                            TelefonoEmergenciaField(
                                countryCode: $signUpViewModel.countryCode,
                                phoneNumber: $signUpViewModel.phoneNumber
                            )
                            
                            Spacer().frame(height: 30)
                            
                            TextoLimiteField(
                                label: "Nombre Completo",
                                placeholder: "Escribe tu nombre Completo...",
                                text: $signUpViewModel.nombreCompleto,
                                maxLength: 40,
                                title: false
                            )
                        }
                        
                        Spacer().frame(height: 30)
                        
                        CustomButton(
                            text: "Continuar",
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            action: {
                                signUpViewModel.validarDatosStep2()
                                if !signUpViewModel.showAlert {
                                    path.append("finalizar")
                                }
                            }
                        )
                    }
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

struct SignInStep2View_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [String] = []

        var body: some View {
            SignUpStep2View(path: $path)
        }
    }
}
