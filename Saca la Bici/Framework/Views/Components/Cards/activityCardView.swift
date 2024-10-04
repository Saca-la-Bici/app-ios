//
//  ActivityCardView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActivityCardView: View {
    var activityTitle: String
    var activityType: String
    var level: String?
    var date: String?
    var time: String?
    var duration: String?
    var imagen: String?
    var location: String?
    var attendees: Int?
    @ObservedObject private var userSessionManager = UserSessionManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Título y Nivel
            HStack {
                Text(activityTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let level = level {
                    Text(level)
                        .font(.caption)
                        .padding(6)
                        .background(
                            level == "Nivel 1" ? Color(red: 129.0 / 255.0, green: 199.0 / 255.0, blue: 132.0 / 255.0) :
                            (level == "Nivel 2" ? Color(red: 56.0 / 255.0, green: 142.0 / 255.0, blue: 60.0 / 255.0) :
                            (level == "Nivel 3" ? Color(red: 253.0 / 255.0, green: 216.0 / 255.0, blue: 53.0 / 255.0) :
                            (level == "Nivel 4" ? Color(red: 255.0 / 255.0, green: 152.0 / 255.0, blue: 0.0 / 255.0) :
                            (level == "Nivel 5" ? Color(red: 244.0 / 255.0, green: 67.0 / 255.0, blue: 54.0 / 255.0) :
                            Color.gray)))))
                        .cornerRadius(8)
                }
                
                if let attendees = attendees {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                        Text("\(attendees)")
                            .foregroundColor(.primary)
                    }
                }
            }
            
            // Fecha
            if let date = date {
                HStack {
                    Text("Fecha")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(date)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            // Hora
            if let time = time {
                HStack {
                    Text("Hora")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(time)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            // Duración
            if let duration = duration {
                HStack {
                    Text("Duración")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(duration)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            // Imagen Placeholder
            if let imagen = imagen {
                WebImage(url: URL(string: imagen))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48, alignment: .center)
            }
            
            // Ubicación
            if let location = location {
                HStack {
                    Text("Ubicación")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(location)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
