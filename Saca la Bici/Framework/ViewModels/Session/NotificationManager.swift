//
//  NotificationManager.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 29/09/24.
//

import Foundation

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    @Published var selectedTab: Int?
}
