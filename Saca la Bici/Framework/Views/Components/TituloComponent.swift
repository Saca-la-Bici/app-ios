//
//  TituloComponent.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 18/09/24.
//

import SwiftUI

struct TituloComponent: View {
    var title: String
    var separator: String?
    var imageName: String
    var separatorBool: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            if separatorBool == true {
                Text(separator ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.961, green: 0.802, blue: 0.048))
            }
            Image(imageName)
                .resizable()
                .frame(width: 40, height: 24)
        }
    }
}
