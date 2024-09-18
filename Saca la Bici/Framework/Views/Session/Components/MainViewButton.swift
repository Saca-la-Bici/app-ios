//
//  MainViewButton.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 18/09/24.
//

import SwiftUI

struct MainViewButton: View {
    var title: String
    var pathValue: String
    var foregroundColor: Color
    var backgroundColor: Color
    var hasOverlay: Bool
    @Binding var path: [String]
    
    var body: some View {
        Button(action: {
            path.append(pathValue)
        }) {
            Text(title)
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .cornerRadius(10)
                .overlay(
                    hasOverlay ? RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1) : nil
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
