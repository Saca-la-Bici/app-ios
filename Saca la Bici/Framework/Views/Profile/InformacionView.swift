//
//  InformacionView.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 15/10/24.
//

import SwiftUI

struct InformacionView: View {
    @Binding var path: [ConfigurationPaths]
    
    @State private var safariURL: URL?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Spacer()
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Políticas de la Aplicación")
                            .foregroundColor(.gray)
                            .font(.callout)
                            .bold()
                            .padding(.leading, 20)
                        
                        Button(action: {
                            safariURL = URL(string: "http://18.220.205.53:8080/politicasAplicacion/politicaPrivacidad")
                        }, label: {
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("Aviso de Privacidad")
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        })
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer().frame(height: 2)
                        
                        Button(action: {
                            safariURL = URL(string: "http://18.220.205.53:8080/politicasAplicacion/terminosCondiciones")
                        }, label: {
                            HStack {
                                Image(systemName: "text.document.fill")
                                Text("Términos y Condiciones")
                                Spacer()
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 25)
                    
                    Divider()
                }
            }
        }
        .navigationTitle("Información")
        .padding(.top, 4)
        .sheet(item: $safariURL) { url in
            SafariView(url: url)
        }
    }
}

struct InformacionView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State var path: [ConfigurationPaths] = []

        var body: some View {
            InformacionView(path: $path)
        }
    }
}
