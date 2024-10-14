//
//  ActividadIndividualViewModel.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 04/10/24.
//

import Foundation
import Combine

@MainActor
class ActividadIndividualViewModel: ObservableObject {
    @Published var datosActividad = ActividadIndividualResponse()
    @Published var messageAlert = ""
    @Published var showAlert = false
    @Published var showAlertSheet = false
    @Published var isLoading: Bool = false
    
    @Published var titulo: String = ""
    @Published var fecha: String = ""
    @Published var hora: String = ""
    @Published var personasInscritas: Int = 0
    @Published var ubicacion: String = ""
    @Published var descripcion: String = ""
    @Published var estado: Bool = false
    @Published var duracion: String = ""
    @Published var tipo: String = ""
    @Published var distancia: String = ""
    @Published var nivel: String = ""
    @Published var imagen: String = ""
    @Published var isJoined: Bool = false
    
    enum AlertType {
        case success
        case error
        case errorIndividual
    }
    
    enum AlertTypeSheet {
        case success
        case error
        case errorInscrito
    }
    
    @Published var alertType: AlertType?
    @Published var alertTypeSheet: AlertTypeSheet?
    
    @Published var codigoAsistencia: String = ""
    @Published var codigoAsistenciaField: String = ""
    
    private let empty = ActividadIndividualResponse()
    private var userSessionManager = UserSessionManager.shared
    
    private let consultarRequirement: ConsultarActividadIndRequirementProtocol
    private let gestionarAsistenciaRequirement: GestionarAsistenciaRequirementProtocol
    private let verificarAsistenciaRequirement: VerificarAsistenciaRequirementProtocol
    
    init(
        consultarActividadIndividualRequirement: ConsultarActividadIndRequirementProtocol = ConsultarActividadIndividualRequirement.shared,
        gestionarAsistenciaRequirement: GestionarAsistenciaRequirementProtocol = GestionarAsistenciaRequirement.shared,
        verificarAsistenciaRequirement: VerificarAsistenciaRequirementProtocol = VerificarAsistenciaRequirement.shared
    ) {
        self.consultarRequirement = consultarActividadIndividualRequirement
        self.gestionarAsistenciaRequirement = gestionarAsistenciaRequirement
        self.verificarAsistenciaRequirement = verificarAsistenciaRequirement
    }
    
    func updateProperties(from actividad: Actividad) {
        self.titulo = actividad.titulo
        self.fecha = actividad.fecha
        self.hora = actividad.hora
        self.personasInscritas = actividad.personasInscritas
        self.ubicacion = actividad.ubicacion
        self.descripcion = actividad.descripcion
        self.estado = actividad.estado
        self.duracion = actividad.duracion
        self.tipo = actividad.tipo
        self.imagen = actividad.imagen ?? ""
    }
    
    @MainActor
    func consultarActividadIndividual(actividadID: String) async {
        self.isLoading = true
        
        self.datosActividad = await consultarRequirement.consultarActividadIndividual(actividadID: actividadID) ?? empty
        
        if !datosActividad.permisos.isEmpty {
            userSessionManager.updatePermisos(newPermisos: datosActividad.permisos)
            
            if let actividad = datosActividad.actividad.informacion.first {
                updateProperties(from: actividad)
                
                // Verificar si el usuario actual está inscrito
                if let currentUserID = userSessionManager.currentUserID {
                    self.isJoined = actividad.usuariosInscritos.contains(currentUserID)
                } else {
                    self.isJoined = false
                }
            } else {
                self.isJoined = false
            }
            
            if self.tipo == "Rodada" {
                self.distancia = datosActividad.actividad.ruta?.distancia ?? ""
                self.nivel = datosActividad.actividad.ruta?.nivel ?? ""
                
                let codigoTemp = datosActividad.actividad.codigoAsistencia ?? 0
                self.codigoAsistencia = String(codigoTemp)
            }
            self.isLoading = false
            
        } else {
            self.messageAlert = "Hubo un error al consultar la actividad. Por favor intente más tarde..."
            self.alertType = .errorIndividual
            self.showAlert = true
        }
    }
    
    @MainActor
    func inscribirActividad(actividadID: String) async {
        guard !isJoined else { return }
        isLoading = true
        do {
            // Actualizar localmente
            self.personasInscritas += 1
            self.isJoined = true

            let response = try await gestionarAsistenciaRequirement.inscribirActividad(actividadId: actividadID, tipo: self.tipo)
            self.messageAlert = response.message
            self.alertType = .success
            self.showAlert = true

            // Refetch para asegurar la consistencia
            await consultarActividadIndividual(actividadID: actividadID)
        } catch let error as NSError {
            // Revertir cambios locales si hay un error
            self.personasInscritas = max(self.personasInscritas - 1, 0)
            self.isJoined = false
            self.messageAlert = error.localizedDescription
            self.alertType = .error
            self.showAlert = true
        }
        isLoading = false
    }

    @MainActor
    func cancelarAsistencia(actividadID: String) async {
        guard isJoined else { return }
        isLoading = true
        do {
            // Actualizar localmente
            self.personasInscritas = max(self.personasInscritas - 1, 0)
            self.isJoined = false

            let response = try await gestionarAsistenciaRequirement.cancelarAsistencia(actividadId: actividadID, tipo: self.tipo)
            self.messageAlert = response.message
            self.alertType = .success
            self.showAlert = true

            // Refetch para asegurar la consistencia
            await consultarActividadIndividual(actividadID: actividadID)
        } catch let error as NSError {
            // Revertir cambios locales si hay un error
            self.personasInscritas += 1
            self.isJoined = true
            self.messageAlert = error.localizedDescription
            self.alertType = .error
            self.showAlert = true
        }
        isLoading = false
    }
    
    @MainActor
    func verificarAsistencia(IDRodada: String, codigoAsistencia: String, adminOrStaff: Bool) async {
        if adminOrStaff == false {
            if codigoAsistenciaField.isEmpty || codigoAsistenciaField.count != 4 {
                self.messageAlert = "Ingresa un código de 4 números para continuar."
                self.showAlertSheet = true
                return
            }
        }
        
        let response = await verificarAsistenciaRequirement.verificarAsistencia(IDRodada: IDRodada, codigo: codigoAsistencia)
        
        if response != nil {
            if response?.status == 400 && response?.message == "Código de asistencia incorrecto" {
                self.messageAlert = "El código de verificación es incorrecto. Por favor intente de nuevo."
                self.showAlertSheet = true
                self.alertTypeSheet = .error
                return
            } else if response?.status == 400 && response?.message == "La rodada no tiene un código de asistencia" {
                self.messageAlert = "La rodada no tiene un código de asistencia."
                self.showAlertSheet = true
                self.alertTypeSheet = .error
                return
            } else if response?.status == 400 && response?.message == "Asistencia ya verificada para esta rodada" {
                self.messageAlert = "Ya verificaste la asistencia para esta rodada. ¡Gracias por participar!"
                self.showAlertSheet = true
                self.alertTypeSheet = .errorInscrito
                return
            } else if response?.status == 200 {
                self.messageAlert = "Tu asistencia ha sido verificada. ¡Gracias por asistir!"
                self.showAlertSheet = true
                self.alertTypeSheet = .success
            }
        } else {
            self.messageAlert = "Hubo un error al verificar tu asistencia. Por favor intentelo de nuevo."
            self.showAlertSheet = true
            return
        }
    }
}
