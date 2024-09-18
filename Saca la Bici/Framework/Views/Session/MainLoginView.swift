//
//  MainLoginView.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 15/09/24.
//

import SwiftUI

struct MainLoginView: View {
    // Para manejar las sesiones
    @EnvironmentObject var sessionManager: SessionManager
    
    // Estado para la pila de navegación
    @State private var path: [String] = []
    
    // ViewModel para pasar a las otras vistas
    @StateObject var signUpViewModel = SignUpViewModel()

    var body: some View {
        NavigationStack(path: $path) { 
            ZStack {
                Group {
                    VStack(alignment: .center) {
                        
                        Image("Logo_SacaLaBici")
                            .resizable()
                            .frame(width: 188.0, height: 147.0)
                        
                        Spacer().frame(height: 30)
                        
                        VStack(alignment: .center, spacing: 20) {
                            VStack(alignment: .center, spacing: 10) {
                                Text("¡Explora y disfruta Querétaro!")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(Color.black)
                                
                                Text("Es genial tenerte aquí.")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .foregroundColor(Color.black)
                            }
                            
                            VStack {
                                // Sign in
                                NavigationLink("Crea una cuenta", value: "register")
                                    .font(.headline)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color(red: 0.961, green: 0.802, blue: 0.048))
                                    .cornerRadius(10)
                                    .buttonStyle(PlainButtonStyle())
                                
                                // Log in
                                NavigationLink("Iniciar sesión", value: "login")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                    .buttonStyle(PlainButtonStyle())
                            }
                            
                            Spacer().frame(height: 0)
                            
                            Text("o continúa con")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity)
                            
                            VStack {
                                Button(action: {
                                    // Acción de autenticación con Google
                                }) {
                                    HStack(alignment: .center, spacing: 15.0) {
                                        Image("GoogleLogo")
                                            .resizable()
                                            .frame(width: 20.0, height: 20.0)
                                        Text("Registrarse con Google")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    // Acción de autenticación con Apple
                                }) {
                                    HStack(alignment: .center, spacing: 15.0) {
                                        Image(systemName: "apple.logo")
                                            .resizable()
                                            .frame(width: 20.0, height: 25.0)
                                            .foregroundColor(.black)
                                        Text("Registrarse con Apple")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            Spacer().frame(height: 10)
                        }
                        .padding(.horizontal, 30.0)
                        .padding(.vertical, 20.0)
                        .background(.white)
                        .cornerRadius(25)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .zIndex(3)
                
                VStack {
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 500)
                        .foregroundColor(Color(red: 0.961, green: 0.802, blue: 0.048))
                }.zIndex(2)
                
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 25)
                        .foregroundColor(Color(red: 0.961, green: 0.802, blue: 0.048))
                }.zIndex(1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.925, green: 0.925, blue: 0.925))
            
            // Definimos las vistas para las rutas de navegación
            .navigationDestination(for: String.self) { value in
                switch value {
                case "login":
                    LoginView()
                case "register":
                    SignUpStep1View(path: $path, signUpViewModel: signUpViewModel)
                case "continue":
                    SignUpStep2View(path: $path, signUpViewModel: signUpViewModel)
                case "finalizar":
                    SignUpStep3View(path: $path, signUpViewModel: signUpViewModel)
                default:
                    EmptyView()
                }
            }
        }
    }
}

struct MainLoginView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoginView()
    }
}

