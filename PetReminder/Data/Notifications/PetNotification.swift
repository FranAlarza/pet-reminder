//
//  PetNotification.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation

struct PetNotification: Identifiable, Equatable {
    let id: String = UUID().uuidString
    var title: String
    var body: String
    var date: Date
    var repeatInterval: NotificationRepeatInterval
    var aditionalNotifications: Bool
}
