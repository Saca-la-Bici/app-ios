//
//  DecalogosView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 16/10/24.
//

import SwiftUI

struct DecalogosView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                AsyncImage(url: URL(string: "https://sacalabucket.s3.us-east-2.amazonaws.com/decalogos/Decalogo+%231.jpeg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.95)
                } placeholder: {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) 
            .navigationTitle("Decalogo del Ciclista")
        }
    }
}

#Preview {
    DecalogosView()
}
