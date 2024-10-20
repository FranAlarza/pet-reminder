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
    @Environment(\.scenePhase) var scenePhase
    private let authService: AuthServiceProtocol = AuthService()
    private let notificationManager: NotificationRepositoryProtocol = NotificationRepository()
    
    var body: some Scene {
        WindowGroup {
            MainTabBar()
                .task {
                    await notificationManager.requestAuthorization()
                    await authService.login()
                }
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        AnalitycsManager.shared.log(.appActive)
                    case .inactive:
                        AnalitycsManager.shared.log(.appInactive)
                    case .background:
                        AnalitycsManager.shared.log(.appBackground)
                    default: break
                    }
                }
        }
    }
}
