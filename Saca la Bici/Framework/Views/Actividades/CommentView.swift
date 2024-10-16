//
//  CommentView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 16/10/24.
//

import SwiftUI

struct CommentView: View {
    
    // Path
    @Binding var path: [ActivitiesPaths]
    
    var body: some View {
        VStack {
            // Main Comment
            CommentCardView(
                name: "John Doe",
                date: "2024-10-16",
                hour: "12:00",
                comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                path: $path
            )
            
            // Titulo
            HStack {
                Text("Respuestas")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.top, 10)
            
            // Respuestas
            VStack(alignment: .leading, spacing: 20) {
                CommentCardView(
                    name: "John Doe",
                    date: "2024-10-16",
                    hour: "12:00",
                    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    isAnswer: true,
                    path: $path
                    
                )
                CommentCardView(
                    name: "John Doe",
                    date: "2024-10-16",
                    hour: "12:00",
                    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    isAnswer: true,
                    path: $path
                    
                )
                CommentCardView(
                    name: "John Doe",
                    date: "2024-10-16",
                    hour: "12:00",
                    comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    isAnswer: true,
                    path: $path
                    
                )
            }
        }
        .padding()
    }
}
