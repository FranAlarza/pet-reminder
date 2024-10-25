//
//  AddReminderFormView.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation
import SwiftUI

enum AddReminderFocusState {
    case title
    case description
}

struct AddReminderFormView: View {
    
    @FocusState var focus: AddReminderFocusState?
    @Binding var petNotification: Notification
    let action: () async -> Void
    private let hapticManager = HapticFeedbackManager.shared

    @Environment(\.dismiss) var dismiss
    
    func validateForm() -> Bool {
        if petNotification.title.isEmpty {
            return false
        }
        
        if petNotification.notificationType.rawValue.isEmpty {
            return false
        }
        
        if petNotification.date <= Date() {
            return false
        }
        
        return true
    }
    
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
                        .focused($focus, equals: .title)
                        .submitLabel(.next)
                        .onSubmit {
                            focus = .description
                        }
                    
                    TextField("Description", text: $petNotification.body)
                        .autocorrectionDisabled()
                        .focused($focus, equals: .description)
                        .submitLabel(.done)
                        .onSubmit {
                            focus = nil
                        }
                }
                
                Section("Frecuency") {
                    Picker("Frecuency", selection: $petNotification.repeatInterval) {
                        ForEach(NotificationRepeatInterval.allCases) { repeatInterval in
                            Text(LocalizedStringResource(stringLiteral: repeatInterval.rawValue)).tag(repeatInterval)
                        }
                    }
                    DatePicker("Initial Date", selection: $petNotification.date)
                    Toggle("Notify me before", isOn: $petNotification.aditionalNotifications)
                }
            }
            
            Button(action: {
                Task {
                    await action()
                    dismiss.callAsFunction()
                    hapticManager.playHapticFeedback(type: .success)
                }
            }) {
                Text("Add Reminder")
                    .padding()
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(validateForm() ? Color(.attributesText) : Color(.attributesText).opacity(0.5))
                    .foregroundStyle(.white)
            }
            .disabled(!validateForm())
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
