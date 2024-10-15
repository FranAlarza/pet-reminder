//
//  ReminderRow.swift
//  PetReminder
//
//  Created by Fran Alarza on 14/10/24.
//

import SwiftUI

struct ReminderRow: View {
    let petNotification: PetNotification
    
    var body: some View {
        HStack {
            Image(systemName: petNotification.notificationType.iconKey)
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                Text(petNotification.title)
                    .font(.headline)
                Text(petNotification.body)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                Label {
                    Text(petNotification.date, style: .time)
                } icon: {
                    Image(systemName: "clock")

                }

                Label {
                    Text(LocalizedStringResource(stringLiteral: petNotification.repeatInterval.rawValue))
                } icon: {
                    Image(systemName: "arrow.counterclockwise")
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                .fill(Color(.systemBackground))
                .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 2)
        }
    }
}

#Preview {
    ReminderRow(
        petNotification: .init(
            title: "Vacuna",
            body: "Toca Vacuna!",
            date: Date(),
            repeatInterval: .monthly,
            notificationType: .medication,
            aditionalNotifications: true
        )
    )
}
