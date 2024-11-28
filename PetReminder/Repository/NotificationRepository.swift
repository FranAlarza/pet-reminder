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
    func scheduleCustomNotification(notification: Notification, timeInterval: TimeInterval, repeats: Bool) async throws
    func deleteAllNotifications()
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
        if notification.repeatInterval == .custom {
            try await scheduleCustomNotification(
                notification: notification,
                timeInterval: notification.customTimeInterval?.interval ?? 0,
                repeats: notification.repeatInterval != .noRepeat
            )
        } else {
            try await scheduleNotification(notification: notification)
            if notification.aditionalNotifications {
                try await scheduleAdditionalNotifications(notification: notification)
            }
        }
        
        try await FirestoreService.request(
                NotificationsEndpoints.postNotifications(
                    animalId: animalId,
                    notification: NotificationDTO(notifcation: notification)
                )
            )
    }
    
    func scheduleCustomNotification(notification: Notification, timeInterval: TimeInterval, repeats: Bool) async throws {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
        print("Custom notification scheduled with interval: \(timeInterval) seconds, repeats: \(repeats)")
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
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notification.id])
                    UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notification.id])
                }
            }
            try await group.waitForAll()
        }
    }
    
    func deleteAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("All notifications have been deleted.")
    }
}

extension NotificationRepository {
    
    private func scheduleNotification(notification: Notification) async throws {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = .default
        
        var trigger: UNNotificationTrigger
        
        switch notification.repeatInterval {
        case .daily:
            trigger = createTrigger(for: notification.date, components: [.hour, .minute], repeats: notification.repeatInterval != .noRepeat)
        case .weekly:
            trigger = createTrigger(for: notification.date, components: [.weekday, .hour, .minute], repeats: notification.repeatInterval != .noRepeat)
        case .monthly:
            trigger = createTrigger(for: notification.date, components: [.day, .hour, .minute], repeats: notification.repeatInterval != .noRepeat)
        case .quarterly:
            trigger = createQuarterlyTrigger(for: notification.date)
        case .annually:
            trigger = createTrigger(for: notification.date, components: [.month, .day, .hour, .minute], repeats: notification.repeatInterval != .noRepeat)
        case .noRepeat:
            trigger = createTrigger(for: notification.date, components: [.year, .month, .day, .hour, .minute], repeats: notification.repeatInterval != .noRepeat)
        case .custom:
            return
        }
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
        print("Notification scheduled with: \(notification.title), \(notification.body), \(notification.date)")
    }
    
    private func createTrigger(for date: Date, components: Set<Calendar.Component>, repeats: Bool) -> UNCalendarNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents(components, from: date)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeats)
    }
    
    private func createQuarterlyTrigger(for date: Date) -> UNCalendarNotificationTrigger {
        let components: Set<Calendar.Component> = [.month, .day, .hour, .minute]
        let triggerDate = Calendar.current.dateComponents(components, from: date)
        
        // Ajustar el mes en intervalos de 3 meses
        var triggerComponents = triggerDate
        triggerComponents.month = (triggerComponents.month ?? 1) % 3 == 0 ? triggerComponents.month : (triggerComponents.month ?? 1) + (3 - ((triggerComponents.month ?? 1) % 3))
        
        return UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
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
