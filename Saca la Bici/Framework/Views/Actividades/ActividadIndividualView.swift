//
//  ActividadIndividualView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 04/10/24.
//

import SwiftUI

struct ActividadIndividualView: View {
    @Binding var path: [ActivitiesPaths]
    var id: String
    
    var body: some View {
        Text(id)
    }
}

struct ActividadIndividualView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ActivitiesPaths] = []
        var id = "662fr3"

        var body: some View {
            ActividadIndividualView(path: $path, id: id)
        }
    }
}
