//
//  DropListPicker.swift
//  Saca la Bici
//
//  Created by Diego Lira on 09/10/24.
//

import SwiftUI

struct DropdownField: View {
    var label: String
    var options: [String]
    @Binding var selectedOption: String
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                    }, label: {
                        Text(option)
                    })
                }
            } label: {
                HStack {
                    Text(selectedOption)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.4)))
            }
        }
    }
}
