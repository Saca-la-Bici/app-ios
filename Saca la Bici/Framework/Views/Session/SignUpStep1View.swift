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
                        VStack(alignment: .leading) {
                            Text("Correo electrónico")
                                .font(.caption)
                            TextField("Correo electrónico", text: $signUpViewModel.email)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
                        
                        // Nombre de usuario
                        VStack(alignment: .leading) {
                            Text("Nombre de usuario")
                                .font(.caption)
                            TextField("Nombre de usuario", text: $signUpViewModel.username)
                                .textInputAutocapitalization(.never)
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
                        
                        Spacer().frame(height: 0)
                        
                        // Fecha de nacimiento
                        VStack(alignment: .leading) {
                            Text("Fecha de Nacimiento")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Esta información no será pública")
                                .font(.caption)
                            
                            Spacer().frame(height: 15)
                            
                            HStack {
                                // Picker de Mes
                                Picker(selection: $signUpViewModel.selectedMonth, label: Text("Mes")) {
                                    ForEach(signUpViewModel.months, id: \.self) {
                                        Text($0)
                                            .foregroundColor(Color(red: 123/255, green: 163/255, blue: 139/255))
                                            .background(Color.clear)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(maxWidth: 180, maxHeight: 130)
                                .cornerRadius(10)
                                .padding(.top, -20)
                                
                                // Picker de Día
                                Picker(selection: $signUpViewModel.selectedDay, label: Text("Día")) {
                                    ForEach(signUpViewModel.days, id: \.self) {
                                        Text($0)
                                            .foregroundColor(Color(red: 123/255, green: 163/255, blue: 139/255))
                                            .background(Color.clear)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(maxWidth: 65, maxHeight: 130)
                                .cornerRadius(10)
                                .padding(.top, -20)
                                
                                // Picker de Año
                                Picker(selection: $signUpViewModel.selectedYear, label: Text("Año")) {
                                    ForEach(signUpViewModel.years, id: \.self) {
                                        Text($0)
                                            .foregroundColor(Color(red: 123/255, green: 163/255, blue: 139/255))
                                            .background(Color.clear)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(maxWidth: 95, maxHeight: 130)
                                .cornerRadius(10)
                                .padding(.top, -20)
                            }
                        }
                        
                        Spacer().frame(height: 10)
                        
                        // Continuar
                        Button(action: {
                            signUpViewModel.validarDatosStep1()
                            if !signUpViewModel.showAlert {
                                path.append("continue")
                            }
                        }) {
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

