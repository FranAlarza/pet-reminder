//
//  NotificationRepeatInterval.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation

enum NotificationRepeatInterval: String, CaseIterable, Identifiable, Codable {
    case noRepeat
    case daily
    case weekly
    case monthly
    case quarterly
    case annually
    
    var id: String { self.rawValue }
}
