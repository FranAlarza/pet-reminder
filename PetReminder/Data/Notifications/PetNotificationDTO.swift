//
//  PetNotificationDTO.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation

struct PetNotificationDTO: FirestoreIdentifiable, Equatable {
    var id: String
    let title: String
    let body: String
    let date: Date
    let repeatInterval: NotificationRepeatInterval
    let aditionalNotifications: Bool
}
