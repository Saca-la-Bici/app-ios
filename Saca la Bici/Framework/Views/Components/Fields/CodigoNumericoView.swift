//
//  FourNumberField.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 13/10/24.
//

import SwiftUI

struct CodigoNumericoView: View {
    @Binding var codigo: String
    let limite: Int
    
    // Para mantener el foco en el campo
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<limite, id: \.self) { index in
                ZStack {
                    // Si hay un número en la posición actual, mostrarlo
                    if index < codigo.count {
                        let charIndex = codigo.index(codigo.startIndex, offsetBy: index)
                        Text(String(codigo[charIndex]))
                            .font(.title)
                            .bold()
                            .frame(width: 40, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    } else {
                        // Placeholder vacío para los dígitos faltantes
                        Text("")
                            .font(.title)
                            .frame(width: 40, height: 50)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .onTapGesture {
            isFocused = true // Focalizar cuando el usuario toca el área
        }
        .overlay(
            // Campo de texto invisible para manejar la entrada
            TextField("", text: $codigo)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .onChange(of: codigo) { _, newValue in
                    // Limitar a solo números y restringir el largo
                    codigo = String(newValue.prefix(limite).filter { $0.isNumber })
                }
                .opacity(0) // Campo de texto oculto
        )
    }
}
