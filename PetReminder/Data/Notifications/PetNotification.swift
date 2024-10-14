//
//  PetNotification.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation

struct PetNotification: Identifiable, Equatable, Hashable {
    let id: String = UUID().uuidString
    var title: String
    var body: String
    var date: Date
    var repeatInterval: NotificationRepeatInterval
    var notificationType: NotificationType
    var aditionalNotifications: Bool
}

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
