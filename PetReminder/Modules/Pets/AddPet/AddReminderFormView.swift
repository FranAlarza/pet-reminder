//
//  AddReminderFormView.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation
import SwiftUI

struct AddReminderFormView: View {
    
    @Binding var petNotification: Notification
    let action: () async -> Void

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Form {
                Section("Choose Type") {
                    HStack(alignment: .center, spacing: 16){
                        ForEach(NotificationType.allCases) { type in
                            Image(systemName: type.iconKey)
                                .padding()
                                .foregroundStyle(petNotification.notificationType == type ? .attributesText : .secondary)
                                .onTapGesture {
                                    print("Selected \(type)")
                                    petNotification.notificationType = type
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Section("Reminder Info") {
                    TextField("Title", text: $petNotification.title)
                        .autocorrectionDisabled()
                    TextField("Description", text: $petNotification.body)
                        .autocorrectionDisabled()
                }
                
                Section("Frecuency") {
                    Picker("Frecuency", selection: $petNotification.repeatInterval) {
                        ForEach(NotificationRepeatInterval.allCases) { repeatInterval in
                            Text(LocalizedStringResource(stringLiteral: repeatInterval.rawValue)).tag(repeatInterval)
                        }
                    }
                    DatePicker("Date", selection: $petNotification.date)
                    Toggle("Notify me before", isOn: $petNotification.aditionalNotifications)
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
                id: "",
                title: "NotiTest",
                body: "DescriptionTest",
                date: Date(),
                repeatInterval: .daily,
                notificationType: .medication,
                aditionalNotifications: true
            )
        ), action: {}
    )
}
