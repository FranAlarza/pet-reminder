//
//  NotificationDTO.swift
//  PetReminder
//
//  Created by Fran Alarza on 16/10/24.
//

import Foundation

struct NotificationDTO: FirestoreIdentifiable, Equatable, Hashable {
    var id: String
    let title: String
    let body: String
    let date: Date
    let repeatInterval: NotificationRepeatInterval
    let notificationType: NotificationType
    let aditionalNotifications: Bool
}

extension NotificationDTO {
    init(notifcation: Notification) {
        id = notifcation.id
        title = notifcation.title
        body = notifcation.body
        date = notifcation.date
        repeatInterval = notifcation.repeatInterval
        notificationType = notifcation.notificationType
        aditionalNotifications = notifcation.aditionalNotifications
    }
}
