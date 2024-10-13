//
//  NotificationManager.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation
import UserNotifications

protocol NotificationManagerProtocol {
    func requestAuthorization() async
    func scheduleNotificationWithAditionalNotification(notification: PetNotification) async throws
}

final class NotificationManager: NotificationManagerProtocol {
    
    func requestAuthorization() async {
        do {
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            try await UNUserNotificationCenter.current().requestAuthorization(options: options)
        } catch {
            print("Error requesting authorization: \(error)")
        }

    }
}

extension NotificationManager {
    func scheduleNotificationWithAditionalNotification(notification: PetNotification) async throws {
        try await scheduleNotification(notification: notification)
        if notification.aditionalNotifications {
            try await scheduleAdditionalNotifications(notification: notification)
        }
    }
    
    private func scheduleNotification(notification: PetNotification) async throws {
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
    
    private func scheduleAdditionalNotifications(notification: PetNotification) async throws {
        if let threeDaysBefore = Calendar.current.date(byAdding: .day, value: -3, to: notification.date) {
            try await scheduleNotification(
                notification: .init(
                    title: notification.title,
                    body: notification.body,
                    date: threeDaysBefore,
                    repeatInterval: .noRepeat,
                    aditionalNotifications: notification.aditionalNotifications
                )
            )
        }
        if let twoDaysBefore = Calendar.current.date(byAdding: .day, value: -2, to: notification.date) {
            try await scheduleNotification(
                notification: .init(
                    title: notification.title,
                    body: notification.body,
                    date: twoDaysBefore,
                    repeatInterval: .noRepeat,
                    aditionalNotifications: notification.aditionalNotifications
                )
            )
        }
        if let oneDayBefore = Calendar.current.date(byAdding: .day, value: -1, to: notification.date) {
            try await scheduleNotification(
                notification: .init(
                    title: notification.title,
                    body: notification.body,
                    date: oneDayBefore,
                    repeatInterval: .noRepeat,
                    aditionalNotifications: notification.aditionalNotifications
                )
            )
        }
    }
}
