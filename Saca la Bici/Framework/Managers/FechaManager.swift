//
//  FechaManager.swift
//  Saca la Bici
//
//  Created by Maria Jose Gaytan Gil on 29/09/24.
//

import Foundation

class FechaManager {
    
    static let shared = FechaManager()
    
    private init() {}
    
    func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            return formatDateCustom(date)
        }
        
        formatter.formatOptions = [.withInternetDateTime]
        if let date = formatter.date(from: dateString) {
            return formatDateCustom(date)
        }
        
        return dateString
    }
    
    func formatDateCustom(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "es_MX")
        return dateFormatter.string(from: date)
    }
}
