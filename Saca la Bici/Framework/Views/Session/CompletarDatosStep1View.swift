//
//  CompletarDatos.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct CompletarDatosStep1View: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var signUpViewModel = SignUpViewModel()
    @State private var path: [String] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    Spacer().frame(height: 30)
                    
                    // Título
                    HStack(alignment: .center, spacing: 15) {
                        Text("Completar Registro")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("_")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.961, green: 0.802, blue: 0.048))
                        Image("Bici")
                            .resizable()
                            .frame(width: 40, height: 24)
                    }
                    
                    Spacer().frame(height: 30)
                    
                    // Formulario Paso 1
                    VStack(alignment: .leading, spacing: 20) {
                        
                        TextoLimiteField(
                            label: "Nombre de usuario",
                            placeholder: "Escribe tu nombre de usuario",
                            text: $signUpViewModel.username,
                            maxLength: 50,
                            title: true
                        )
                        
                        Spacer().frame(height: 5)
                        
                        // Fecha de nacimiento
                        FechaNacimientoPicker(
                            selectedMonth: $signUpViewModel.selectedMonth,
                            selectedDay: $signUpViewModel.selectedDay,
                            selectedYear: $signUpViewModel.selectedYear,
                            months: signUpViewModel.months,
                            days: signUpViewModel.days,
                            years: signUpViewModel.years
                        )
                    }
                    
                    Spacer().frame(height: 30)
                    
                    CustomButton(
                        text: "Continuar",
                        backgroundColor: Color(red: 0.961, green: 0.802, blue: 0.048),
                        action: {
                            signUpViewModel.validarCompletarDatos1()
                            if !signUpViewModel.showAlert {
                                path.append("completarDatos")
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
                    
                    Spacer()
                }
                .padding(30)
                .frame(maxWidth: .infinity)
            }
            .alert(isPresented: $signUpViewModel.showAlert) {
                Alert(
                    title: Text("Oops!"),
                    message: Text(signUpViewModel.messageAlert)
                )
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "completarDatos":
                    CompletarDatosStep2View(path: $path, signUpViewModel: signUpViewModel)
                default:
                    EmptyView()
                }
            }
        }
        .onAppear {
            // Configurar el closure para actualizar el SessionManager
            signUpViewModel.onProfileComplete = {
                sessionManager.actualizarEstadoPerfilCompleto(true)
            }
        }
    }
}
