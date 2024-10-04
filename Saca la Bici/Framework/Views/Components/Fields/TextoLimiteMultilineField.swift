//
//  TextoLimiteMultiline.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 02/10/24.
//

import SwiftUI
import Combine

struct TextoLimiteMultilineField: View {
    var label: String?
    var placeholder: String = ""
    @Binding var text: String
    var maxLength: Int = 150
    var title: Bool = false
    var showCharacterCount: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let label = label {
                if title {
                    Text(label)
                        .font(.title3)
                        .bold()
                } else {
                    Text(label)
                        .font(.caption)
                }
            }
            
            TextField(placeholder, text: $text, axis: .vertical)
                .lineLimit(5, reservesSpace: true)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .onReceive(Just(text)) { _ in
                    if text.count > maxLength {
                        text = String(text.prefix(maxLength))
                    }
                }
            
            if showCharacterCount {
                Text("\(text.count)/\(maxLength)")
                    .font(.caption2)
                    .foregroundColor(text.count >= maxLength ? .red : .gray)
                    .padding(.top, 2)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.vertical, 5)
    }
}
