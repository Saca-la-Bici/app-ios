//
//  ResultView.swift
//  viewsTest
//
//  Created by Jesus Cedillo on 09/09/24.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject var loginViewModel = LoginViewModel()
    
    var body: some View {
        VStack { // Añadimos VStack para organizar los elementos verticalmente
            Button {
                Task {
                    await loginViewModel.probarToken()
                }
            } label: {
                Text("Probar Token")
                    .font(.subheadline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color(red: 0.961, green: 0.802, blue: 0.048))
                    .cornerRadius(10)
            }
            .padding()
            .buttonStyle(PlainButtonStyle())
            
            Text(loginViewModel.textTest)
                .padding() 
            
            Button {
                sessionManager.signOut()
            } label: {
                Text("Cerrar Sesión")
                    .font(.subheadline)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.black)
                    .background(.red)
                    .cornerRadius(10)
            }
            .padding()
            .buttonStyle(PlainButtonStyle())
        }
        .padding() // Padding general para el VStack
    }
}
