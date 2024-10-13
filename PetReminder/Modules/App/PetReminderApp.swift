//
//  PetReminderApp.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct PetReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let authService: AuthServiceProtocol = AuthService()
    private let notificationManager: NotificationManagerProtocol = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            MainTabBar()
                .task {
                    do {
                        await notificationManager.requestAuthorization()
                        try await Auth.auth().signInAnonymously()
                        print("[PetReminderApp] - Signed in anonymously")
                        await authService.login()
                    } catch {
                        print("[PetReminderApp] - Error signing in anonymously: \(error)")
                    }
                }
        }
    }
}
