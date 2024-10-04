//
//  FechaNacimientoPicker.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 17/09/24.
//

import SwiftUI

struct FechaNacimientoPicker: View {
    @Binding var fechaSeleccion: Date
    
    let startDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    let endDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    
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
                     in: startDate...endDate,
                     displayedComponents: [.date]
                )
            .datePickerStyle(.wheel)
            .frame(maxHeight: 80)
            .clipped()
            .background(Color.clear)
        }
    }
}
