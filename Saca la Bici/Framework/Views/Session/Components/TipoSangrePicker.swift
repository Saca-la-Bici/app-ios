//
//  TipoSangrePicker.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct TipoSangrePicker: View {
    @Binding var selectedBloodType: String
    var bloodTypes: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tipo de Sangre")
                .font(.caption)
            
            Picker("Tipo de sangre", selection: $selectedBloodType) {
                ForEach(bloodTypes, id: \.self) { bloodType in
                    Text(bloodType)
                        .foregroundColor(Color(red: 123/255, green: 163/255, blue: 139/255))
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity, maxHeight: 130)
            .cornerRadius(10)
            .padding(.top, -20)
        }
    }
}
