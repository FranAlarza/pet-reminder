//
//  NotificationService.swift
//  PetReminder
//
//  Created by Fran Alarza on 18/10/24.
//

import Foundation

protocol NotificationServiceProtocol {
    func scheduleNotificationWithAditionalNotification(notification: Notification, animalId: String) async throws
    func removeNotification(animalId: String, notificationId: String) async throws
    func removeAllNotifications(animalId: String) async throws
}

final class NotificationService: NotificationServiceProtocol {
    
    private let repository: NotificationRepositoryProtocol
    
    init(repository: NotificationRepositoryProtocol = NotificationRepository()) {
        self.repository = repository
    }
    
    func scheduleNotificationWithAditionalNotification(notification: Notification, animalId: String) async throws {
        try await repository.scheduleNotificationWithAditionalNotification(notification: notification, animalId: animalId)
    }
    
    func removeNotification(animalId: String, notificationId: String) async throws {
        try await repository.removeNotification(animalId: animalId, notificationIdentifier: notificationId)
    }
    
    func removeAllNotifications(animalId: String) async throws {
        try await repository.deleteAllNotifications(animalId: animalId)
    }
}
