//
//  SignInStep1View.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import SwiftUI

struct SignUpStep1View: View {
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
                        Image("Bici")
                            .resizable()
                            .frame(width: 40, height: 24)
                        
                    }
                    
                    Spacer().frame(height: 50)
                    
                    // Formulario
                    VStack(alignment: .leading,spacing: 20) {
                        
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
                            selectedMonth: $signUpViewModel.selectedMonth,
                            selectedDay: $signUpViewModel.selectedDay,
                            selectedYear: $signUpViewModel.selectedYear,
                            months: signUpViewModel.months,
                            days: signUpViewModel.days,
                            years: signUpViewModel.years
                        )
                        
                        Spacer().frame(height: 10)
                        
                        CustomButton(
                            text: "Continuar",
                            backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                            action: {
                                signUpViewModel.validarDatosStep1()
                                if !signUpViewModel.showAlert {
                                    path.append("continue")
                                }
                            }
                        )
                    }
                    
                    Spacer()
                }
                .padding(30)
                .frame(maxWidth: .infinity)
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

struct SignInStep1View_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [String] = []

        var body: some View {
            SignUpStep1View(path: $path)
        }
    }
}

