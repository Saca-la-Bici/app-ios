//
//  CommentCardView.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 16/10/24.
//

import SwiftUI

struct CommentCardView: View {
    
    // Parametros
    @State var name: String
    @State var date: String
    @State var hour: String
    @State var comment: String
    @State var isAnswer: Bool = false
    
    // Path
    @Binding var path: [ActivitiesPaths]
    
    var body: some View {
        
        // Wrapper
        VStack(alignment: .leading, spacing: 20) {
            // Header
            HStack(alignment: .center, spacing: 20) {
                
                // Foto de perfil
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                
                // Nombre, fecha y hora
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Text("\(date)  -  \(hour)")
                        .font(.caption)
                }
                
                Spacer()
                
                // Ellipsis
                Button(action: {
                    //
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .rotationEffect(.degrees(90))
                })
            }
            
            // Comentario
            HStack {
                // Texto del comentario
                Text(comment)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            if !isAnswer {
                // Botón de ver comentarios
                Button {
                    path.append(.answers)
                } label: {
                    HStack(alignment: .center, spacing: 15) {
                        // Icono
                        Label("123", systemImage: "message")
                            .foregroundColor(.black)
                    }
                }
            }
            
            // Divisor
            Divider()
            
        }
        
    }
}
