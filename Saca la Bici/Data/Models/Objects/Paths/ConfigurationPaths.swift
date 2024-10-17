//
//  ConfigurationPaths.swift
//  Saca la Bici
//
//  Created by Jesus Cedillo on 26/09/24.
//

import Foundation

enum ConfigurationPaths: Hashable {
    case configuration
    case olvidar
    case profile
    case password
    case ayuda
    case informacion
    case comoUsarApp
    case faqs
    case asignacionRoles
    case desactivarUsuarios
    case faqDetail (faq: FAQ, permisos: [String])
    case addFAQ
    case updateFAQ (faq: FAQ)
    case editProfile
}
