//
//  PetReminderApp.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI

@main
struct PetReminderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let authService: AuthServiceProtocol = AuthService()
    
    var body: some Scene {
        WindowGroup {
            MainTabBar()
                .task {
                    await authService.login()
                }
        }
    }
}
