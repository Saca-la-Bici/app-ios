//
//  TextoLimiteField.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI
import Combine

struct TextoLimiteField: View {
    var label: String
    var placeholder: String
    @Binding var text: String
    var maxLength: Int
    var title: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if title == true {
                Text(label)
                    .font(.title3)
                    .bold()
            } else {
                Text(label)
                    .font(.caption)
            }
            
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .padding()
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .onReceive(Just(text)) { _ in
                    if text.count > maxLength {
                        text = String(text.prefix(maxLength))
                    }
                }
        }
    }
}
