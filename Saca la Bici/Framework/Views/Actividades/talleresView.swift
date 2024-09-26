//
//  talleresView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI

struct TalleresView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ActivityCardView(
                    activityTitle: "Taller de Ciclismo 1",
                    date: "Jueves 5 junio 2025",
                    time: "13:00",
                    location: "Epigmenio González",
                    attendees: 32
                )
                
                ActivityCardView(
                    activityTitle: "Taller de Ciclismo 2",
                    date: "Viernes 12 septiembre 2025",
                    time: "10:00",
                    location: "Centro de Convenciones",
                    attendees: 120
                )
            }
            .padding(.horizontal)
        }
    }
}

struct TalleresView_Previews: PreviewProvider {
    static var previews: some View {
        TalleresView()
    }
}
