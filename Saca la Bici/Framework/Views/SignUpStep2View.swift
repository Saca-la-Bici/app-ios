//
//  SignInStep2View.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 16/09/24.
//

import SwiftUI
import Combine

struct SignUpStep2View: View {
    
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
                        Text("___")
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
                        
                        // Contraseña
                        VStack(alignment: .leading) {
                            
                            Text("Información Adicional")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Spacer().frame(height: 20)
                            
                            Text("Tipo de Sangre")
                                .font(.caption)
                            Picker("Tipo de sangre", selection: $signUpViewModel.selectedBloodType) {
                                ForEach(signUpViewModel.bloodTypes, id: \.self) {
                                    Text($0)
                                        .foregroundColor(Color(red: 123/255, green: 163/255, blue: 139/255))
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(maxWidth: .infinity, maxHeight: 130)
                            .cornerRadius(10)
                            .padding(.top, -20)
                            
                            Text("Número de Emergencia")
                                .font(.caption)
                            HStack {
                                Text("+")
                                    .font(.title2)
                                    .padding(.leading, 10)

                                TextField("País", text: $signUpViewModel.countryCode)
                                    .keyboardType(.numberPad)
                                    .frame(width: 60)
                                    .padding()
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .onReceive(Just(signUpViewModel.countryCode)) { _ in
                                        if signUpViewModel.countryCode.count > 3 {
                                            signUpViewModel.countryCode = String(signUpViewModel.countryCode.prefix(3))
                                        }
                                    }
                                
                                TextField("Teléfono", text: $signUpViewModel.phoneNumber)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .onReceive(Just(signUpViewModel.phoneNumber)) { _ in
                                        if signUpViewModel.phoneNumber.count > 12 {
                                            signUpViewModel.phoneNumber = String(signUpViewModel.phoneNumber.prefix(12))
                                        }
                                    }
                            }
                            
                            Spacer().frame(height: 30)
                            
                            
                            Text("Nombre Completo")
                                .font(.caption)
                            TextField("Escribe tu nombre Completo", text: $signUpViewModel.nombreCompleto)
                                .keyboardType(.numberPad)
                                .padding()
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .onReceive(Just(signUpViewModel.nombreCompleto)) { _ in
                                    if signUpViewModel.nombreCompleto.count > 40 {
                                        signUpViewModel.nombreCompleto = String(signUpViewModel.nombreCompleto.prefix(40))
                                    }
                                }
                        }
                        
                        Spacer().frame(height: 30)
                        
                        Button {
                            signUpViewModel.validarDatosStep2()
                            if !signUpViewModel.showAlert {
                                path.append("finalizar")
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
