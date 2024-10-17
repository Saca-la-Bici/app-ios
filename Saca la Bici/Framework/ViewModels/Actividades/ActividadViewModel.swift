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
    @Published var tituloActividad: String = ""
    @Published var ubicacionActividad: String = ""
    @Published var descripcionActividad: String = ""

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
    @Published var tituloAlertaRuta = ""
    @Published var showAlert = false
    @Published var reloadRutas = false
    @Published var showAlertDescripcion = false
    @Published var tipoActividad: String = ""
    @Published var navTitulo: String = ""
    @Published var guardarBoton: String = ""
    
    @Published var rutas: [Ruta] = []
    @Published var selectedRuta: Ruta?
    
    @Published var isLoading: Bool = false
    
    enum ActiveAlert: Identifiable {
        case error
        case success

        var id: Int {
            hashValue
        }
    }
    
    @Published var alertTypeRuta: AlertTypeRuta?
    
    enum AlertTypeRuta: Identifiable {
        case delete(ruta: Ruta)
        case validation
        
        var id: UUID {
            switch self {
            case .delete:
                return UUID()
            case .validation:
                return UUID() 
            }
        }
    }
    
    // Estado de alerta
    @Published var activeAlert: ActiveAlert?

    var registrarActividadRequirement: RegistrarActividadRequirementProtocol

    init(registrarActividadRequirement: RegistrarActividadRequirementProtocol = RegistrarActividadRequirement.shared) {
        self.registrarActividadRequirement = registrarActividadRequirement
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
    }

    @MainActor
    private var durationFormatter: String {
        let hours = Int(selectedTimeDuration) / 3600
        let minutes = (Int(selectedTimeDuration) % 3600) / 60
        return String(format: "%d horas %d minutos", hours, minutes)
    }

    @MainActor
    func validarDatosBase() async {
        if self.tituloActividad.trimmingCharacters(in: .whitespaces).isEmpty || self.ubicacionActividad.trimmingCharacters(in: .whitespaces).isEmpty {
            self.showAlert = true
            self.messageAlert = "Alguno de los datos está vacío. Por favor, rellene todos los campos."
            return
        }
        
        self.isLoading = true
        
        let rutas = await registrarActividadRequirement.getRutas()
        
        if rutas == nil {
            self.showAlert = true
            self.messageAlert = "Hubo un error al obtener las rutas. Por favor, intente más tarde."
            return
        } else {
            self.rutas = rutas?.rutas ?? []
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func validarRuta() {
        if self.selectedRuta == nil {
            self.showAlert = true
            self.alertTypeRuta = .validation
            self.messageAlert = "No seleccionó una ruta. Por favor, seleccione una ruta."
            self.tituloAlertaRuta = "Oops!"
            return
        }
    }

    @MainActor
    func setTitulo() {
        if self.tipoActividad == "Evento" {
            self.navTitulo = "Registrar Evento"
        } else if self.tipoActividad == "Taller" {
            self.navTitulo = "Registrar Taller"
        } else if self.tipoActividad == "Rodada" {
            self.navTitulo = "Registrar Rodada"
        }
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
        if self.descripcionActividad.trimmingCharacters(in: .whitespaces).isEmpty {
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
                                            imagen: self.selectedImageData, tipo: self.tipoActividad,
                                            ubicacion: self.ubicacionActividad, ruta: self.selectedRuta?._id)

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
    func eliminarActividad(IDRuta: String) async {
        let responseStatus = await registrarActividadRequirement.eliminarRuta(IDRuta: IDRuta)
        
        if responseStatus == 200 {
            self.showAlert = true
            self.alertTypeRuta = .validation
            self.reloadRutas = true
            self.messageAlert = "La ruta se eliminó correctamente."
            self.tituloAlertaRuta = "¡Éxito!"
        } else if responseStatus == 500 {
            self.showAlert = true
            self.alertTypeRuta = .validation
            self.messageAlert = "Hubo un error al eliminar la ruta. Por favor intente de nuevo."
            self.tituloAlertaRuta = "Oops!"
            return
        }
    }

}
