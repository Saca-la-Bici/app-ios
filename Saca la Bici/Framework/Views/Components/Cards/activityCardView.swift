//
//  ActivityCardView.swift
//  template
//
//  Created by Maria Jose Gaytan Gil on 05/09/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ActivityCardView: View {
    
    @Binding var path: [ActivitiesPaths]
    
    var id: String
    var activityTitle: String
    var activityType: String
    var level: String?
    var date: String?
    var time: String?
    var duration: String?
    var imagen: String?
    var location: String?
    var attendees: Int?
    
    @State var seeCard: Bool = true
    
    let colorManager = ColorManager()
    
    // ViewModels
    @StateObject var actividadViewModel = ActividadViewModel()
    @StateObject var rodadasViewModel = RodadasViewModel()
    @StateObject var talleresViewModel = TalleresViewModel()
    @StateObject var eventosViewModel = EventosViewModel()

    var body: some View {
        if seeCard {
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
                                levelColor(for: level)
                            )
                            .cornerRadius(8)
                    }
                    
                    if let attendees = attendees {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                            Text("\(attendees)")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Modificar / Eliminar actividad
                    Menu {
                        Button(action: {
                            // Acción para modificar la actividad
                            if activityType == "Rodada" {
                                path.append(.editarRodada(id: id))
                            } else if activityType == "Evento" {
                                path.append(.editarEvento(id: id))
                            } else if activityType == "Taller" {
                                path.append(.editarTaller(id: id))
                            }
                        }, label: {
                            Label("Modificar actividad", systemImage: "pencil")
                        })

                        Button(action: {
                            // Acción para eliminar la actividad
                            actividadViewModel.activeAlert = .delete
                        }, label: {
                            Label("Eliminar actividad", systemImage: "trash")
                                .foregroundColor(.red)
                        })
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.black)
                            .rotationEffect(.degrees(90))
                            .padding()
                    }

                }
                
                if let date = date {
                    infoRow(title: "Fecha", value: date)
                }
                
                if let time = time {
                    infoRow(title: "Hora", value: time)
                }
                
                if let duration = duration {
                    infoRow(title: "Duración", value: duration)
                }
                
                if let location = location {
                    infoRow(title: "Ubicación", value: location)
                }
                
                // Imagen Placeholder
                if let imagen = imagen {
                    GeometryReader { geometry in
                        WebImage(url: URL(string: imagen))
                            .resizable()
                            .scaledToFill()
                            .frame(width: min(geometry.size.width, 350), height: 200)
                            .cornerRadius(8)
                            .clipped()
                        }
                    .frame(height: 200)
                }
                
                let verde = colorManager.colorFromHex("7DA68D")
                
                Button(action: {
                    path.append(.detalle(id: id))
                }, label: {
                    HStack {
                        Text("Ver detalles")
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(verde)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Image(systemName: "arrow.forward.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(verde)
                    }
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 8)
                
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 1))
            .shadow(radius: 5)
            .alert(item: $actividadViewModel.activeAlert) { alert in
                switch alert {
                case .success:
                    return Alert(
                        title: Text("Éxito"),
                        message: Text(actividadViewModel.messageAlert),
                        dismissButton: .default(Text("OK"))
                    )
                case .error:
                    return Alert(
                        title: Text("Error"),
                        message: Text(actividadViewModel.messageAlert),
                        dismissButton: .default(Text("OK"))
                    )
                case .delete:
                    return Alert(
                        title: Text("¿Seguro quieres eliminar la actividad?"),
                        message: Text("Una vez eliminada no se podrá recuperar."),
                        primaryButton: .destructive(Text("Eliminar")) {
                            Task {
                                await actividadViewModel.eliminarActividad(id: id, tipo: activityType)
                                
                                self.seeCard = false
                            }
                        },
                        secondaryButton: .cancel(Text("Cancelar"))
                    )
                }
            }
        }
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
    
    private func levelColor(for level: String) -> Color {
        switch level {
        case "Nivel 1":
            return Color(red: 129.0 / 255.0, green: 199.0 / 255.0, blue: 132.0 / 255.0)
        case "Nivel 2":
            return Color(red: 56.0 / 255.0, green: 142.0 / 255.0, blue: 60.0 / 255.0)
        case "Nivel 3":
            return Color(red: 253.0 / 255.0, green: 216.0 / 255.0, blue: 53.0 / 255.0)
        case "Nivel 4":
            return Color(red: 255.0 / 255.0, green: 152.0 / 255.0, blue: 0.0 / 255.0)
        case "Nivel 5":
            return Color(red: 244.0 / 255.0, green: 67.0 / 255.0, blue: 54.0 / 255.0)
        default:
            return Color.gray
        }
    }
}

struct ActivityCard_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ActivitiesPaths] = []

        var body: some View {
            ActivityCardView(
                path: $path,
                id: "1",
                activityTitle: "Lorem ipsum dolor sit amet ms",
                activityType: "Rodada",
                level: "Nivel 1",
                date: "12/0/2",
                time: "12:00",
                duration: "2 horas",
                attendees: 100
            )
        }
    }
}
