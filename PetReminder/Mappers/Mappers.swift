//
//  Mappers.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation

struct Mappers {

    static func mapPetDTO(_ from: PetNotification) -> PetNotificationDTO {
        return .init(
            id: from.id,
            title: from.title,
            body: from.body,
            date: from.date,
            repeatInterval: from.repeatInterval,
            aditionalNotifications: from.aditionalNotifications
        )
    }
}
