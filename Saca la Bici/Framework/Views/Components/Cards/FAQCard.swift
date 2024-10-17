//
//  FAQCard.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI

struct FAQCard<PathType: Equatable>: View {
    
    // Parametros
    var faq: FAQ
    var permisos: [String]
    
    @Binding var path: [PathType]
    var nextPath: PathType?
    
    var body: some View {
        Button {
            if nextPath != nil {
                path.append(nextPath!)
            }
        } label: {
            HStack {
                Text(faq.Pregunta)
                Spacer()
                Image(systemName: "chevron.forward")
                    .scaleEffect(1)
            }
        }
    }
}
