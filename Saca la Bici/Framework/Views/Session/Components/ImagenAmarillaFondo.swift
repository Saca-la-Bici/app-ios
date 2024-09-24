//
//  ImagenAmarillaFondo.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 18/09/24.
//

import SwiftUI

struct ImagenAmarillaFondo: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height * 1.2))
        path.addCurve(to: CGPoint(x: rect.width, y: rect.height * 0.6),
                      control1: CGPoint(x: rect.width * 0.3, y: rect.height),
                      control2: CGPoint(x: rect.width * 0.7, y: rect.height * 0.01))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}
