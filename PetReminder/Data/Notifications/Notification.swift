//
//  Notification.swift
//  PetReminder
//
//  Created by Fran Alarza on 16/10/24.
//

import Foundation

struct Notification: Identifiable, Equatable, Hashable {
    let id: String
    var title: String
    var body: String
    var date: Date
    var repeatInterval: NotificationRepeatInterval
    var notificationType: NotificationType
    var aditionalNotifications: Bool
}

extension Notification: Codable {
    init() {
        id = UUID().uuidString
        title = ""
        body = ""
        date = Date()
        repeatInterval = .daily
        notificationType = .medication
        aditionalNotifications = false
    }
}

extension Notification {
    init(dto: NotificationDTO) {
        id = dto.id
        title = dto.title
        body = dto.body
        date = dto.date
        repeatInterval = dto.repeatInterval
        notificationType = dto.notificationType
        aditionalNotifications = dto.aditionalNotifications
    }
}
