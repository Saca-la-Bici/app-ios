//
//  ProfileView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 26/09/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var path: [ConfigurationPaths] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button {
                    Task {
                        path.append(.configuration)
                    }
                } label: {
                    Text("Configuración")
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
            }
            .navigationDestination(for: ConfigurationPaths.self) { value in
                switch value {
                case .configuration:
                    ConfigurationView(path: $path)
                case .profile:
                    RestablecerContrasenaView(path: $path)
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
