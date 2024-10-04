//
//  YellowButton.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct CustomButton: View {
    var text: String
    var backgroundColor: Color
    var foregroundColor: Color = .black
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
