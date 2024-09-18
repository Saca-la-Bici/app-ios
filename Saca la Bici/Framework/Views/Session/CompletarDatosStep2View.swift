//
//  CompletarDatosStep2View.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct CompletarDatosStep2View: View {
    @Binding var path: [String]
    @EnvironmentObject var sessionManager: SessionManager
    @ObservedObject var signUpViewModel: SignUpViewModel

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
                    .offset(y: 50)
            }
            .ignoresSafeArea()
            .zIndex(1)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Título
                    TituloComponent(title: "Completar Registro", separator: "__", imageName: "Bici", separatorBool: true)
                    
                    Spacer().frame(height: 30)
                    
                    // Formulario Paso 2
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Tipo de Sangre
                        TipoSangrePicker(
                            selectedBloodType: $signUpViewModel.selectedBloodType,
                            bloodTypes: signUpViewModel.bloodTypes
                        )
                        
                        // Teléfono de Emergencia
                        TelefonoEmergenciaField(
                            countryCode: $signUpViewModel.countryCode,
                            phoneNumber: $signUpViewModel.phoneNumber
                        )
                    }
                    
                    Spacer().frame(height: 30)
                    
                    // Botón para completar el registro
                    CustomButton(
                        text: "Continuar",
                        backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                        action: {
                            Task {
                                await signUpViewModel.completarRegistro()
                            }
                        }
                    )
                    
                    Spacer().frame(height: 0)
                    
                    // Botón para continuar con otra cuenta
                    CustomButton(
                        text: "Continuar con otra cuenta",
                        backgroundColor: .red,
                        action: {
                            sessionManager.signOut()
                        }
                    )
                    
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
