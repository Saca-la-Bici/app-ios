import SwiftUI
import Foundation

struct EventView: View {
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @StateObject private var viewModel = ActividadViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.eventos.isEmpty {
                    Text("No estás inscrito en ningúna actividad.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // AQUI VA EL FOR
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.getActividades()
                        print(viewModel.eventos)
                    } catch {
                        showErrorAlert = true
                    }
                }
                
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
