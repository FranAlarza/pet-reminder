//
//  NotificationRepeatInterval.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation

enum NotificationRepeatInterval: String, CaseIterable, Identifiable {
    case none = "No Repetir"
    case daily = "Diariamente"
    case weekly = "Semanalmente"
    case monthly = "Mensualmente"
    case quarterly = "Trimestralmente"
    case annually = "Anualmente"
    
    var id: String { self.rawValue }
}
