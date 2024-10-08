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
                    VStack {
                        Image(systemName: "pawprint.fill")
                        Text("Pets")
                    }
                }
            SettingsScreen()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
        }
    }
}

#Preview {
    MainTabBar()
}
