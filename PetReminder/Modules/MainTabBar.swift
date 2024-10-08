//
//  MainTabBar.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI

struct MainTabBar: View {
    var body: some View {
        TabView {
            PetsScreen()
                .tabItem {
                    Image(systemName: "pawprint.fill")
                }
            SettingsScreen()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
}

#Preview {
    MainTabBar()
}
