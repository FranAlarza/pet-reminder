//
//  NotificationType.swift
//  PetReminder
//
//  Created by Fran Alarza on 17/10/24.
//

import Foundation

enum NotificationType: String, Identifiable, CaseIterable, Codable {
    case vaccination
    case medication
    case playtime
    case other
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .vaccination: return "Vaccination"
        case .medication: return "Medication"
        case .playtime: return "Playtime"
        case .other: return "Other"
        }
    }
    
    var iconKey: String {
        switch self {
        case .vaccination: return "syringe.fill"
        case .medication: return "pill.fill"
        case .playtime: return "tennisball.fill"
        case .other: return "questionmark.circle.fill"
        }
    }
}
