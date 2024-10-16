//
//  ForoView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 16/10/24.
//

import SwiftUI

struct ForoView: View {
    
    // Path
    @Binding var path: [ActivitiesPaths]
    
    var body: some View {
        
        // Wrapper
        VStack {
            
            // Número de comentarios
            HStack {
                Text("123 Comentarios")
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            // Divisor
            Divider()
            
            Spacer()
                .frame(height: 20)
            
            // Lista muestra
            VStack(alignment: .leading, spacing: 20) {
                CommentCardView(
                    name: "John Doe",
                    date: "2024-10-16",
                    hour: "12:00",
                    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    path: $path
                )
                CommentCardView(
                    name: "John Doe",
                    date: "2024-10-16",
                    hour: "12:00",
                    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    path: $path
                )
                CommentCardView(
                    name: "John Doe",
                    date: "2024-10-16",
                    hour: "12:00",
                    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    path: $path
                )
            }
        
        }
        
    }
}
