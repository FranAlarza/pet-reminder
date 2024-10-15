//
//  MainTabBar.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI

struct MainTabBar: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() 
        appearance.backgroundColor = UIColor.systemGray6 
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                PetsScreen()
            }
            .tabItem {
                VStack {
                    Image(systemName: "pawprint.fill")
                    Text("Pets")
                }
            }
            
            NavigationStack {
                SettingsScreen()
            }
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
