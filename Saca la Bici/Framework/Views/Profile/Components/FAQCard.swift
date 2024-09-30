//
//  FAQCard.swift
//  Saca la Bici
//
//  Created by Diego Antonio García Padilla on 29/09/24.
//

import SwiftUI

struct FAQCard: View {
    
    // Parametros
    var faq: FAQ
    @Binding var path: [ConfigurationPaths]
    var nextPath: ConfigurationPaths?
    
    var body: some View {
        Button {
            if nextPath != nil {
                path.append(nextPath!)
            }
        } label: {
            HStack {
                Text(faq.Pregunta)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundColor(Color(.black))
                    .scaleEffect(1)
            }
        }
    }
}
