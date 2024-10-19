//
//  NotificationManager.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation
import UserNotifications

protocol NotificationRepositoryProtocol {
    func requestAuthorization() async
    func scheduleNotificationWithAditionalNotification(notification: Notification, animalId: String) async throws
    func removeNotification(animalId: String, notificationIdentifier: String) async throws
    func deleteAllNotifications(animalId: String) async throws
}

final class NotificationRepository: NotificationRepositoryProtocol {
    
    func requestAuthorization() async {
        do {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            try await UNUserNotificationCenter.current().requestAuthorization(options: options)
        } catch {
            print("Error requesting authorization: \(error)")
        }
        
    }
    func scheduleNotificationWithAditionalNotification(notification: Notification, animalId: String) async throws {
        try await scheduleNotification(notification: notification)
        if notification.aditionalNotifications {
            try await scheduleAdditionalNotifications(notification: notification)
        }
        try await FirestoreService.request(
                NotificationsEndpoints.postNotifications(
                    animalId: animalId,
                    notification: NotificationDTO(notifcation: notification)
                )
            )
    }
    
    func removeNotification(animalId: String, notificationIdentifier: String) async throws {
        try await FirestoreService.request(NotificationsEndpoints.deleteReminders(animalId: animalId, notificationId: notificationIdentifier))
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationIdentifier])
    }
    
    func deleteAllNotifications(animalId: String) async throws {
        let reminders: [NotificationDTO] = try await FirestoreService.request(NotificationsEndpoints.getNotifications(animalId))
        try await withThrowingTaskGroup(of: Void.self) { group in
            for notification in reminders {
                group.addTask {
                    try await FirestoreService.request(NotificationsEndpoints.deleteReminders(animalId: animalId, notificationId: notification.id))
                }
            }
            try await group.waitForAll()
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [])
    }
}

extension NotificationRepository {

    
    private func scheduleNotification(notification: Notification) async throws {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = .default
        
        var trigger: UNCalendarNotificationTrigger
        
        switch notification.repeatInterval {
        case .daily:
            trigger = createTrigger(for: notification.date, components: [.hour, .minute], repeats: true)
        case .weekly:
            trigger = createTrigger(for: notification.date, components: [.weekday, .hour, .minute], repeats: true)
        case .monthly:
            trigger = createTrigger(for: notification.date, components: [.day, .hour, .minute], repeats: true)
        case .quarterly:
            trigger = createTrigger(for: notification.date, components: [.month, .day, .hour, .minute], repeats: false)
        case .annually:
            trigger = createTrigger(for: notification.date, components: [.month, .day, .hour, .minute], repeats: true)
        case .noRepeat:
            trigger = createTrigger(for: notification.date, components: [.year, .month, .day, .hour, .minute], repeats: false)
        }
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
        print("Notification scheduled with: \(notification.title), \(notification.body), \(notification.date)")
    }
    
    private func createTrigger(for date: Date, components: Set<Calendar.Component>, repeats: Bool) -> UNCalendarNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents(components, from: date)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeats)
    }
    
    private func scheduleAdditionalNotifications(notification: Notification) async throws {
        if let threeDaysBefore = Calendar.current.date(byAdding: .day, value: -3, to: notification.date) {
            try await scheduleNotification(
                notification: .init(
                    id: notification.id,
                    title: notification.title,
                    body: notification.body,
                    date: threeDaysBefore,
                    repeatInterval: .noRepeat,
                    notificationType: notification.notificationType,
                    aditionalNotifications: notification.aditionalNotifications
                )
            )
        }
        if let twoDaysBefore = Calendar.current.date(byAdding: .day, value: -2, to: notification.date) {
            try await scheduleNotification(
                notification: .init(
                    id: notification.id,
                    title: notification.title,
                    body: notification.body,
                    date: twoDaysBefore,
                    repeatInterval: .noRepeat,
                    notificationType: notification.notificationType,
                    aditionalNotifications: notification.aditionalNotifications
                )
            )
        }
        if let oneDayBefore = Calendar.current.date(byAdding: .day, value: -1, to: notification.date) {
            try await scheduleNotification(
                notification: .init(
                    id: notification.id,
                    title: notification.title,
                    body: notification.body,
                    date: oneDayBefore,
                    repeatInterval: .noRepeat,
                    notificationType: notification.notificationType,
                    aditionalNotifications: notification.aditionalNotifications
                )
            )
        }
    }
}
