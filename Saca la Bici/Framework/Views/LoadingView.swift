//
//  LoadingView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 18/09/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center){
            
            Image("Logo_SacaLaBici")
                .resizable()
                .frame(width: 188.0, height: 147.0)
            
            Spacer().frame(height: 80)
            
            Image(systemName: "circle.circle")
                .resizable()
                .foregroundColor(Color.gray)
                .frame(width: 30.0, height: 30.0)

        }
    }
}

#Preview {
    LoadingView()
}
