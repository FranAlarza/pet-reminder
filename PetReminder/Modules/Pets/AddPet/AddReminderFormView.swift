//
//  AddReminderFormView.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation
import SwiftUI

/**
 struct PetNotification: Identifiable {
     let id: String = UUID().uuidString
     let title: String
     let body: String
     let date: Date
     let repeatInterval: NotificationRepeatInterval
 }
 */
struct AddReminderFormView: View {
    
    @Binding var petNotification: PetNotification
    let action: () async -> Void

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section("Add Reminder") {
                    TextField("Title", text: $petNotification.title)
                    TextField("Description", text: $petNotification.body)
                }
                
                Section("Frecuency") {
                    Picker("Frecuency", selection: $petNotification.repeatInterval) {
                        ForEach(NotificationRepeatInterval.allCases) { repeatInterval in
                            Text(repeatInterval.rawValue).tag(repeatInterval)
                        }
                    }
                    DatePicker("Date", selection: $petNotification.date)
                    Toggle("Notify me the days before", isOn: $petNotification.aditionalNotifications)
                }
            }
            
            Button(action: {
                Task {
                    await action()
                    dismiss.callAsFunction()
                }
            }) {
                Text("Add Reminder")
                    .padding()
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.attributesText))
                    .foregroundStyle(.white)
            }
            .cornerRadius(16)
            .padding(.horizontal)
            Spacer()
        }
    }
}

#Preview {
    AddReminderFormView(
        petNotification: .constant(
            .init(
                title: "NotiTest",
                body: "DescriptionTest",
                date: Date(),
                repeatInterval: .daily,
                aditionalNotifications: true
            )
        ), action: {}
    )
}
