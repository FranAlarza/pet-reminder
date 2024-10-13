//
//  PetNotification.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation

struct PetNotification: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let body: String
    let date: Date
    let repeatInterval: NotificationRepeatInterval
}
