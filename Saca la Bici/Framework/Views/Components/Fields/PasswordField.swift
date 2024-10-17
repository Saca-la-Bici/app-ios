//
//  PasswordField.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    @Binding var isPasswordVisible: Bool
    var placeholder: String = "Contraseña"
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.caption)
            
            ZStack {
                if isPasswordVisible {
                    TextField(placeholder, text: $password)
                        .textInputAutocapitalization(.never)
                } else {
                    SecureField(placeholder, text: $password)
                        .textInputAutocapitalization(.never)
                }
            }
            .padding()
            .cornerRadius(10)
            .overlay(
                HStack {
                    Spacer()
                    Button(action: {
                        isPasswordVisible.toggle() // Muestra u oculta la contraseña
                    }, label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                            .padding()
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
        }
    }
}
