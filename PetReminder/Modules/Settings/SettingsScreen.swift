//
//  SettingsScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI
import StoreKit
import Shake

struct SettingsScreen: View {
    @Environment(\.requestReview) var requestReview
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                List {
                    Section("INFO") {
                        Button {
                            AnalitycsManager.shared.log(.rateUs)
                            requestReview.callAsFunction()
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: "star.fill")
                                Text("Rate Us")
                                    .foregroundStyle(.primary)
                                    .font(.body)
                                Spacer()

                            }
                        }
                        
                        Button {
                            AnalitycsManager.shared.log(.shakeOpen)
                            Shake.show()
                        } label: {
                            HStack(spacing: 20) {
                                Image(systemName: "lightbulb.fill")
                                Text("Request New Feature")
                                    .foregroundStyle(.primary)
                                    .font(.body)
                                Spacer()
                            }
                        }
                    }
                    
                }
                .listStyle(.insetGrouped)
            }
            HStack(spacing: 4) {
                Text("Made with")
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                
                Text("by")
                
                Link("Fran Alarza", destination: URL(string: "https://www.linkedin.com/in/francisco-javier-alarza-sanchez/")!)
                    .foregroundColor(.blue)
                    .bold()
            }
            .offset(y: -UIScreen.main.bounds.height * 0.25)
            .font(.body)
        }
    }
}

#Preview {
    SettingsScreen()
}
