//
//  ActividadViewModel.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 30/09/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
class ActividadViewModel: ObservableObject {
    @Published var showRegistrarActividadSheet = false
    
    // Modelo Actividad
    private var actividadResponse: ActividadResponse?

    // Campos actividad
    @Published var idActividad: String = ""
    @Published var tituloActividad: String = ""
    @Published var ubicacionActividad: String = ""
    @Published var descripcionActividad: String = ""
    
    // Imagen
    @Published var existingImageURL: URL?
    @Published var existingImageData: Data?
    @Published var selectedItem: PhotosPickerItem?
    @Published var selectedImageData: Data?
    
    @Published var selectedTime: Date = {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = 21
        components.minute = 00
        return Calendar.current.date(from: components) ?? Date()
    }()
    @Published var selectedDate = Date()
    @Published var selectedTimeDuration: TimeInterval = 150 * 60
    
    @Published var messageAlert = ""
    @Published var showAlert = false
    @Published var showAlertDescripcion = false
    @Published var tipoActividad: String = ""
    @Published var navTitulo: String = ""
    @Published var guardarBoton: String = ""
    
    @Published var isEditing: Bool = false
    
    enum ActiveAlert: Identifiable {
        case error
        case success
        case delete
        
        var id: Int {
            hashValue
        }
    }
    
    // Estado de alerta
    @Published var activeAlert: ActiveAlert?
    
    var registrarActividadRequirement: RegistrarActividadRequirementProtocol
    var modificarActividadRequirement: ModificarActividadRequirementProtocol
    var eliminarActividadRequirement: EliminarActividadRequirementProtocol
    
    init(
        registrarActividadRequirement: RegistrarActividadRequirementProtocol = RegistrarActividadRequirement.shared,
        modificarActividadRequirement: ModificarActividadRequirementProtocol = ModificarActividadRequirement.shared,
        eliminarActividadRequirement: EliminarActividadRequirementProtocol = EliminarActividadRequirement.shared
    ) {
        self.registrarActividadRequirement = registrarActividadRequirement
        self.modificarActividadRequirement = modificarActividadRequirement
        self.eliminarActividadRequirement = eliminarActividadRequirement
    }
    
    @MainActor
    func reset() {
        showRegistrarActividadSheet = false
        tituloActividad = ""
        ubicacionActividad = ""
        descripcionActividad = ""
        selectedItem = nil
        selectedImageData = nil
        selectedTime = {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 21
            components.minute = 00
            return Calendar.current.date(from: components) ?? Date()
        }()
        selectedDate = Date()
        selectedTimeDuration = 150 * 60
        messageAlert = ""
        showAlert = false
        showAlertDescripcion = false
        tipoActividad = ""
        navTitulo = ""
        guardarBoton = ""
        isEditing = false
    }
    
    @MainActor
    private var durationFormatter: String {
        let hours = Int(selectedTimeDuration) / 3600
        let minutes = (Int(selectedTimeDuration) % 3600) / 60
        return String(format: "%d horas %d minutos", hours, minutes)
    }
    
    @MainActor
    func validarDatosBase() {
        if self.tituloActividad.isEmpty || self.ubicacionActividad.isEmpty {
            self.showAlert = true
            self.messageAlert = "Alguno de los datos está vacío. Por favor, rellene todos los campos."
            return
        }
    }
    
    @MainActor
    func setTitulo() {
        
        var titulo = ""
        
        // Comprobar si está registrando eo editando
        if self.isEditing {
            titulo += "Editar "
        } else {
            titulo += "Registrar "
        }
        
        if self.tipoActividad == "Evento" {
            titulo += "Evento"
        } else if self.tipoActividad == "Taller" {
            titulo += "Taller"
        } else if self.tipoActividad == "Rodada" {
            titulo += "Rodada"
        }
        
        self.navTitulo = titulo
    }
    
    @MainActor
    func setGuardarBoton() {
        if self.tipoActividad == "Evento" {
            self.guardarBoton = "Guardar Evento"
        } else if self.tipoActividad == "Taller" {
            self.guardarBoton = "Guardar Taller"
        } else if self.tipoActividad == "Rodada" {
            self.guardarBoton = "Guardar Rodada"
        }
    }
    
    @MainActor
    func registrarActividad() async {
        if self.descripcionActividad.isEmpty {
            self.activeAlert = .error
            self.messageAlert = "La descripción de la actividad se encuentra vacía. Por favor, rellene el campo."
            return
        }
        
        let formatoHora = DateFormatter()
        formatoHora.dateFormat = "HH:mm"
        
        let formatoFecha = DateFormatter()
        formatoFecha.dateFormat = "yyyy-MM-dd"
        
        let horaString = formatoHora.string(from: self.selectedTime)
        let fechaString = formatoFecha.string(from: self.selectedDate)
        
        let duracionString = durationFormatter
        
        let datosRegistrar = DatosActividad(titulo: self.tituloActividad, fecha: fechaString, hora: horaString,
                                            duracion: duracionString, descripcion: self.descripcionActividad,
                                            imagen: self.selectedImageData, tipo: self.tipoActividad, ubicacion: self.ubicacionActividad)
        
        do {
            let responseStatus = try await registrarActividadRequirement.registrarActividad(actividad: datosRegistrar)
            
            if responseStatus == 500 {
                self.messageAlert = "Hubo un error al registrar la actividad. Inténtelo de nuevo más tarde."
                self.activeAlert = .error
            } else {
                self.messageAlert = "La actividad fue registrada correctamente."
                self.activeAlert = .success
            }
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                self.messageAlert = "No tienes conexión a Internet. Verifica tu conexión e intenta nuevamente."
                self.activeAlert = .error
            case .timedOut:
                self.messageAlert = "La solicitud ha excedido el tiempo de espera. Inténtalo de nuevo más tarde."
                self.activeAlert = .error
            default:
                self.messageAlert = "Hubo un error al registrar la actividad. Inténtelo de nuevo más tarde."
                self.activeAlert = .error
            }
        } catch {
            self.messageAlert = "Hubo un error al registrar la actividad. Inténtelo de nuevo más tarde."
            self.activeAlert = .error
        }
    }
    
    @MainActor
    func modificarActividad() async {

        // Validar que la descripción no esté vacía
        if self.descripcionActividad.isEmpty {
            self.activeAlert = .error
            self.messageAlert = "La descripción de la actividad se encuentra vacía. Por favor, rellene el campo."
            return
        }
        
        // Formateadores de hora
        let formatoHora = DateFormatter()
        formatoHora.dateFormat = "HH:mm"
        
        // Formateadores de fecha
        let formatoFecha = DateFormatter()
        formatoFecha.dateFormat = "yyyy-MM-dd"
        
        // Fecha y hora formateada
        let horaString = formatoHora.string(from: self.selectedTime)
        let fechaString = formatoFecha.string(from: self.selectedDate)
        
        // Duracion
        let duracionString = self.parseDurationString(duration: self.selectedTimeDuration)
        
        // Referencia a actividadResponse?.informacion[0]
        let info = self.actividadResponse?.informacion[0]
        
        // Obtener imagen
        let imagen: Data? = self.existingImageData ?? self.selectedImageData ?? nil
        
        let datosActividad = ModificarActividadModel(
            id: self.idActividad,
            titulo: self.tituloActividad,
            fecha: fechaString,
            hora: horaString,
            personasInscritas: info?.personasInscritas ?? 0,
            ubicacion: self.ubicacionActividad,
            descripcion: self.descripcionActividad,
            estado: info?.estado ?? true,
            duracion: duracionString,
            imagen: imagen,
            tipo: info?.tipo ?? "",
            foro: info?.foro,
            usuariosInscritos: info?.usuariosInscritos ?? [],
            ruta: actividadResponse?.ruta?._id
        )
            
        do {
            // Modificar actividad
            _ = try await modificarActividadRequirement.modificarActividad(
                id: self.idActividad,
                datosActividad: datosActividad
            )
            
            // Exito
            if isEditing {
                self.messageAlert = "La actividad fue modificada correctamente."
                self.activeAlert = .success
            } else {
                self.messageAlert = "La actividad fue registrada correctamente."
                self.activeAlert = .success
            }
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                self.messageAlert = "No tienes conexión a Internet. Verifica tu conexión e intenta nuevamente."
                self.activeAlert = .error
            case .timedOut:
                self.messageAlert = "La solicitud ha excedido el tiempo de espera. Inténtalo de nuevo más tarde."
                self.activeAlert = .error
            default:
                self.messageAlert = "Hubo un error al modificar la actividad. Inténtelo de nuevo más tarde."
                self.activeAlert = .error
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            self.messageAlert = "Hubo un error desconocido al modificar la actividad. Inténtelo de nuevo más tarde."
            self.activeAlert = .error
        }
        
    }
    
    @MainActor
    func eliminarActividad(id: String, tipo: String) async {
        do {
            _ = try await eliminarActividadRequirement.eliminarActividad(id: id, tipo: tipo)
            
            self.messageAlert = "Actividad eliminada correctamente."
            self.activeAlert = .success
        } catch {
            self.messageAlert = "Hubo un error al eliminar la actividad. Inténtelo de nuevo más tarde."
            self.activeAlert = .error
        }
    }
    
    @MainActor
    func getActividad() async {
        
        let actividadIndividualResponse = await modificarActividadRequirement.consultarActividadIndividual(actividadId: self.idActividad)
        
        self.actividadResponse = actividadIndividualResponse?.actividad ?? nil
        
        let actividad = self.actividadResponse?.informacion[0] ?? nil
        
        if actividad != nil {
            
            // Rellenar los campos
            self.existingImageURL = URL(string: actividad!.imagen ?? "")
            self.existingImageData = await self.getDataFromURL(url: existingImageURL!)
            self.selectedDate = parseDate(date: actividad!.fecha)
            self.tituloActividad = actividad!.titulo
            self.selectedTime = parseTime(time: actividad!.hora)
            self.ubicacionActividad = actividad!.ubicacion
            self.descripcionActividad = actividad!.descripcion
            self.selectedTimeDuration = parseDurationTime(duration: actividad!.duracion)
        } else {
            // Mensaje de error
            self.messageAlert = "No se encontró la actividad."
            self.activeAlert = .error
        }
        
    }
    
    private func parseDate(date: String) -> Date {
        
        // DateFormater
        let dateFormatter = DateFormatter()
        
        // Establecer el formato adecuado de la fecha
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Configurar la zona horaria en UTC
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        // Convertir el string a Date
        return dateFormatter.date(from: date)!
    }
    
    private func parseTime(time: String) -> Date {
        
        // DateFormater
        let dateFormatter = DateFormatter()

        // Establecer el formato adecuado de la fecha
        dateFormatter.dateFormat = "HH:mm"

        // Convertir el string a Date
        return dateFormatter.date(from: time)!
    }
    
    private func parseDurationTime(duration: String) -> TimeInterval {
        
        // Variables
        var hours: Int = 0
        var minutes: Int = 0
        
        // Obtener lista de palabras
        let words = duration.split(separator: " ")
        
        // Si tiene horas
        if words[1] == "horas" {
            hours = Int(words[0])!
            minutes = Int(words[2])!
        } else {
            minutes = Int(words[0])!
        }
        
        // Calcular el TimeInterval en segundos
        let totalSeconds = (hours * 3600) + (minutes * 60)
        
        // Retornar el TimeInterval
        return TimeInterval(totalSeconds)
    }
    
    func parseDurationString(duration: TimeInterval) -> String {
        
        let hours: Int = Int(duration / 3600)
        let minutes: Int = Int((duration.truncatingRemainder(dividingBy: 3600)) / 60)
        
        return "\(hours) horas \(minutes) minutos"
                                                            
    }
    
    func getDataFromURL(url: URL) async -> Data? {
        do {
            // Usa URLSession para obtener los datos
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
}
