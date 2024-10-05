//
//  ActividadIndividualViewModel.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 04/10/24.
//

import Foundation

class ActividadIndividualViewModel: ObservableObject {
    @Published var datosActividad = ActividadIndividualResponse()
    @Published var messageAlert = ""
    @Published var showAlert = false
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
    @Published var imagen: String?
    
    let empty = ActividadIndividualResponse()
    
    private var userSessionManager = UserSessionManager.shared
    let consultarActividadIndividualRequirement: ConsultarActividadIndRequirementProtocol
    
    init(consultarActividadIndividualRequirement: ConsultarActividadIndRequirementProtocol = ConsultarActividadIndividualRequirement.shared) {
        self.consultarActividadIndividualRequirement = consultarActividadIndividualRequirement
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
        self.imagen = actividad.imagen
    }
    
    @MainActor
    func consultarActividadIndividual(actividadID: String) async {
        self.isLoading = true
        
        self.datosActividad = await consultarActividadIndividualRequirement.consultarActividadIndividual(actividadID: actividadID) ?? empty
        
        userSessionManager.updatePermisos(newPermisos: datosActividad.permisos)
        
        if let actividad = datosActividad.actividad.informacion.first {
            updateProperties(from: actividad)
        }
        
        if self.tipo == "Rodada" {
            self.distancia = datosActividad.actividad.ruta?.distancia ?? ""
            self.nivel = datosActividad.actividad.ruta?.nivel ?? ""
        }
        
        self.isLoading = false
    }
}
