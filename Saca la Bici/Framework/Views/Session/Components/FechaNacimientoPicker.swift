//
//  FechaNacimientoPicker.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct FechaNacimientoPicker: View {
    @Binding var fechaSeleccion: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Fecha de Nacimiento")
                .font(.title3)
                .fontWeight(.bold)
            Text("Esta información no será pública")
                .font(.caption)
            
            Spacer().frame(height: 20)
            
            DatePicker(
                    "",
                     selection: $fechaSeleccion,
                     in: ...Calendar.current.date(byAdding: .year, value: -13, to: Date())!,
                     displayedComponents: [.date]
                )
            .datePickerStyle(.wheel)
            .frame(maxHeight: 80)
            .clipped()
            .colorInvert()
                    .colorMultiply(Color(red: 123/255, green: 163/255, blue: 139/255))
            .background(Color.clear)
        }
    }
}
