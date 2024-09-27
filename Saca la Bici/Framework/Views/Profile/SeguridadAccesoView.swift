//
//  SeguridadAccesoView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 26/09/24.
//

import SwiftUI

struct SeguridadAccesoView: View {
    @ObservedObject var restablecerContraseñaViewModel = RestablecerContraseñaViewModel()
    
    @Binding var path: [ConfigurationPaths]
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 8) {
                    Image("Profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    
                    Text("Guadalupe Rojas")
                        .font(.system(size: 15))
                    
                    Spacer().frame(height: 40)
                    
                    VStack(alignment: .leading) {
                        Text("Datos sobre tu cuenta")
                            .foregroundColor(.gray)
                            .font(.callout)
                            .bold()
                            .padding(.leading, 20)
                        
                        HStack {
                            Image(systemName: "calendar")
                                .scaleEffect(1.5)
                            VStack(alignment: .leading) {
                                Text("Fecha en la que se unió")
                                Text("Enero de 2025")
                            }
                            .padding(.leading, 20)
                        }
                        .padding()
                        .padding(.horizontal, 5)
                        
                        if restablecerContraseñaViewModel.showRestablecer == true {
                            Divider()
                            
                            Spacer().frame(height: 20)
                            
                            Text("Seguridad y acceso a la cuenta")
                                .foregroundColor(.gray)
                                .font(.callout)
                                .bold()
                                .padding(.leading, 20)
                            
                            Spacer().frame(height: 20)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                BotonSection(icono: "person.badge.key",
                                             titulo: "Restablece tu contraseña",
                                             button: true,
                                             path: $path,
                                             nextPath: .password)
                            }
                            .padding(.horizontal, 15)
                        }
                        
                        Spacer().frame(height: 40)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                // Acción para eliminar cuenta
                            }, label: {
                                Text("Eliminar cuenta")
                                    .fontWeight(.bold)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 100)
                                    .background(Color.red)
                                    .cornerRadius(25)
                                    .shadow(radius: 5)
                            })
                            .buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical)
                .padding(.top, 20)
            }
            .navigationTitle("Tu Cuenta")
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
        }
    }
}

struct SeguridadAccesoView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ConfigurationPaths] = []

        var body: some View {
            SeguridadAccesoView(path: $path)
        }
    }
}
