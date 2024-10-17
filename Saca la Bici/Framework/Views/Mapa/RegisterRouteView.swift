import SwiftUI
import MapboxMaps

struct RegisterRouteView: View {
    @ObservedObject private var viewModel: RegisterRouteViewModel
    
    init(routeCoordinates: Binding<[CLLocationCoordinate2D]>, distance: Binding<Double>, isAddingRoute: Binding<Bool>) {
        self.viewModel = RegisterRouteViewModel(routeCoordinates: routeCoordinates, distance: distance, isAddingRoute: isAddingRoute)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    Group {
                        TextField("Título", text: $viewModel.title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        TextField("Duración (ej. 4h)", text: $viewModel.duration)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        Picker("Selecciona el nivel", selection: $viewModel.selectedLevel) {
                            ForEach(1..<6) { level in
                                Text("Nivel \(level)").tag(level)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        
                        Text("Distancia: \(viewModel.distance, specifier: "%.2f") km")
                            .padding()
                    }
                    
                    if !viewModel.message.isEmpty {
                        Text(viewModel.message)
                            .foregroundColor(.green)
                            .bold()
                            .padding()
                    }
                    
                    MapViewContainer(routeCoordinates: $viewModel.routeCoordinates,
                                     distance: $viewModel.distance,
                                     isAddingRoute: $viewModel.isAddingRoute,
                                     message: $viewModel.message)
                        .frame(height: 400)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            
            Button {
                viewModel.undoLastPoint()
            } label: {
                Text("Deshacer último punto")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!viewModel.routeCoordinates.isEmpty ? Color.orange : Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }
            .disabled(viewModel.routeCoordinates.isEmpty)
            
            Button {
                viewModel.submitRoute()
            } label: {
                Text(viewModel.isSubmitting ? "Registrando..." : "Registrar Ruta")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.routeCoordinates.count == 7 ? Color.yellow : Color.gray)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .padding(.horizontal)
            }
            .disabled(viewModel.routeCoordinates.count != 7 || viewModel.isSubmitting)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Registro de Ruta"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }

        }
        .padding(.top)
        .navigationTitle("Agrega una ruta")
        .onAppear {
            viewModel.isAddingRoute = true
        }
        .onDisappear {
            viewModel.isAddingRoute = false
        }
    }
}
