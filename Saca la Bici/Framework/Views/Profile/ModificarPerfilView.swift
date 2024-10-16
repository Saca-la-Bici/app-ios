import SwiftUI
import Combine
import PhotosUI

struct ModificarPerfilView: View {

    @StateObject private var consultarPerfilPropioViewModel = ConsultarPerfilPropioViewModel.shared
    @StateObject private var modificarPerfilViewModel = ModificarPerfilViewModel()
    @State var isLoading: Bool = false
    @Binding var path: [ConfigurationPaths]

    @State var nombre: String = ""
    @State var nombreUsuario: String = ""
    @State var tipoSangre: String = ""
    @State var telefonoEmergencia: String = ""
    @State var resultado: String = ""
    @State var mostrarAlerta: Bool = false

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data? // Para almacenar la imagen seleccionada

    let tiposSangre = [ "Sin seleccionar", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    profileHeader() // Encabezado del perfil con la imagen seleccionada
                    formFields() // Campos del formulario
                }
                .navigationTitle("Editar Perfil")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        saveButton() // Botón para guardar cambios
                    }
                }
                .onAppear {
                    // Inicializa los valores del perfil al aparecer la vista
                    let profile = consultarPerfilPropioViewModel.profile
                    nombre = profile?.nombre ?? ""
                    nombreUsuario = profile?.username ?? ""
                    tipoSangre = profile?.tipoSangre ?? "Sin seleccionar"
                    telefonoEmergencia = profile?.numeroEmergencia ?? ""
                    
                    // Si el perfil tiene una imagen, cargarla en selectedImageData
                    if let imageUrlString = profile?.imagen, let imageUrl = URL(string: imageUrlString) {
                        Task {
                            do {
                                let (data, _) = try await URLSession.shared.data(from: imageUrl)
                                selectedImageData = data
                            } catch {
                                print("Error al cargar la imagen: \(error)")
                            }
                        }
                    }
                }
                .alert("Resultado", isPresented: $mostrarAlerta) {
                    Button("Aceptar", role: .cancel) {
                        if resultado == "Perfil modificado correctamente" {
                            path.removeLast() // Solo regresa si el perfil fue modificado exitosamente
                        }
                    }
                } message: {
                    Text(resultado)
                }
                .overlay(
                    Group {
                        if isLoading {
                            ZStack {
                                Color.white // Fondo completamente blanco
                                    .ignoresSafeArea() // Para que ocupe toda la pantalla
                                ProgressView("Mandando información...")
                            }
                        }
                    }
                )
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func profileHeader() -> some View {
        VStack {
            // Pasamos los bindings para permitir seleccionar una nueva imagen
            ImagePickerProfile(
                selectedItem: $selectedItem,
                selectedImageData: $selectedImageData,
                imageUrlString: consultarPerfilPropioViewModel.profile?.imagen
            )
            .padding(.top, 20)
        }
    }

    @ViewBuilder
    private func formFields() -> some View {
        VStack(spacing: 15) {
            TextoLimiteField(label: "Nombre", placeholder: "Nombre", text: $nombre, maxLength: 40)
            TextoLimiteField(label: "Nombre de usuario", placeholder: "Nombre de usuario", text: $nombreUsuario, maxLength: 25)
            VStack(alignment: .leading) {
                Text("Teléfono de Emergencia")
                    .font(.caption)
                
                HStack {
                    Text("+")
                        .font(.title2)
                        .padding(.leading, 10)
                    
                    TextField("Teléfono de Emergencia", text: $telefonoEmergencia)
                        .keyboardType(.numberPad)
                        .padding()
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .onReceive(Just(telefonoEmergencia)) { _ in
                            if telefonoEmergencia.count > 15 {
                                telefonoEmergencia = String(telefonoEmergencia.prefix(15))
                            }
                        }
                }
                
            }
            
            TipoSangrePicker(selectedBloodType: $tipoSangre, bloodTypes: tiposSangre)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func saveButton() -> some View {
        Button {
            Task {
                isLoading = true
                resultado = await modificarPerfilViewModel.modificarPerfil(
                    nombre: nombre,
                    username: nombreUsuario,
                    tipoSangre: tipoSangre,
                    numeroEmergencia: telefonoEmergencia,
                    imagen: selectedImageData // Se envía la imagen seleccionada (si existe)
                )
                mostrarAlerta = true
                isLoading = false
            }
        } label: {
            Image(systemName: "checkmark")
                .foregroundColor(Color(red: 193.0 / 255.0, green: 182.0 / 255.0, blue: 3.0 / 255.0))
        }
    }
    
}
