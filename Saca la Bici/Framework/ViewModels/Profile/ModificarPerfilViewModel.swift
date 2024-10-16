import Foundation

class ModificarPerfilViewModel: ObservableObject {

    let modificarPerfilRequirement = ModificarPerfilRequirement()
    
    @Published var messageAlert = ""
    @Published var alertTitle = ""
    @Published var showAlert = false
    private var resultado: String = ""
    
    // Función que se encargará de validar los datos antes de enviarlos
    @MainActor
    func validarDatos(nombre: String, username: String, tipoSangre: String, numeroEmergencia: String, usernameActual: String) async -> Bool {
        // Validar que el nombre no esté vacío y solo contenga texto
        if nombre.isEmpty || !isOnlyText(nombre) {
            self.messageAlert = "El nombre ingresado no es válido."
            self.alertTitle = "Oops!"
            self.showAlert = true
            return false
        }
        
        // Validar que el nombre de usuario no esté vacío y no contenga solo números o caracteres especiales
        if username.isEmpty || !isNotOnlyNumbers(username) || !isNotOnlySpecialCharacters(username) {
            self.messageAlert = "El nombre de usuario ingresado no es válido."
            self.alertTitle = "Oops!"
            self.showAlert = true
            return false
        }
        
        // Validar que el número de emergencia no esté vacío y contenga solo números
        if numeroEmergencia.isEmpty || !isOnlyNumbers(numeroEmergencia) {
            self.messageAlert = "El número de emergencia ingresado no es válido."
            self.alertTitle = "Oops!"
            self.showAlert = true
            return false
        }
        
        if username != usernameActual {
            let usernameExistente = await modificarPerfilRequirement.verificarUsernameExistente(username: username)
            
            if usernameExistente == true {
                self.messageAlert = "Este nombre de usuario ya está tomado. Por favor usa otro."
                self.alertTitle = "Oops!"
                self.showAlert = true
                return false
            }
        }

        // Si todas las validaciones pasan
        return true
    }
    
    @MainActor
    func modificarPerfil(nombre: String, username: String, tipoSangre: String, numeroEmergencia: String, imagen: Data?, usernameExistente: String) async -> String {
        
        // Validar los datos antes de proceder
        guard await validarDatos(nombre: nombre, username: username, tipoSangre: tipoSangre,
                                 numeroEmergencia: numeroEmergencia, usernameActual: usernameExistente) else {
            return messageAlert // Ahora se retorna el mensaje personalizado
        }

        do {
            let tipoSangreEnviar = tipoSangre == "Sin seleccionar" ? "" : tipoSangre
            
            // Se envía la imagen seleccionada o nil si se desea eliminar la imagen
            resultado = try await modificarPerfilRequirement.modificarPerfil(
                nombre: nombre, username: username,
                tipoSangre: tipoSangreEnviar, numeroEmergencia: numeroEmergencia, imagen: imagen
            )
            self.alertTitle = "¡Éxito!"
            resultado = "Perfil modificado correctamente"
        } catch {
            print("Error: \(error.localizedDescription)")
            self.alertTitle = "Oops!"
            resultado = "Error al modificar el perfil, intentelo más tarde"
        }
        
        return resultado
    }
    
    // Validar que el nombre solo contenga texto
    func isOnlyText(_ text: String) -> Bool {
        let regex = "^[\\p{L} ]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }

    // Validar que el texto no contenga solo números
    func isNotOnlyNumbers(_ text: String) -> Bool {
        let regex = "^(?!\\d+$).+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }

    // Validar que el texto no contenga solo caracteres especiales
    func isNotOnlySpecialCharacters(_ text: String) -> Bool {
        let regex = "^(?=.*[A-Za-z0-9]).+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
    
    // Validar que el número de emergencia solo contenga números
    func isOnlyNumbers(_ text: String) -> Bool {
        let regex = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
}
