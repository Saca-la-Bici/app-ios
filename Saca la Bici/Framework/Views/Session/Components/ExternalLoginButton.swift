//
//  ExternalLoginButton.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 18/09/24.
//

import SwiftUI

struct ExternalLoginButton: View {
    let action: () async -> Void
    let buttonText: String
    let imageName: String
    let systemImage: Bool
    
    var body: some View {
        Button(action: {
            Task {
                await action()
            }
        }) {
            HStack(alignment: .center, spacing: 15.0) {
                if systemImage == true {
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 20.0, height: 25.0)
                        .foregroundColor(.black)
                } else {
                    Image(imageName)
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                }
                Text(buttonText)
                    .font(.subheadline)
                    .foregroundColor(Color.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
