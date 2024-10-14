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
            notificationType: from.notificationType,
            aditionalNotifications: from.aditionalNotifications
        )
    }
    
    static func mapPetNotification(_ from: PetNotificationDTO) -> PetNotification {
        return .init(
            title: from.title,
            body: from.body,
            date: from.date,
            repeatInterval: from.repeatInterval,
            notificationType: from.notificationType,
            aditionalNotifications: from.aditionalNotifications
        )
    }
    
    static func mapPets(_ pets: [PetDTO]) async throws -> [Pet] {
        return try await withThrowingTaskGroup(of: Pet.self, returning: [Pet].self) { group in
            var result: [Pet] = []
            
            for pet in pets {
                group.addTask {
                    let image = await FirestoreService.downloadImage(pet.image)
                    let reminders: [PetNotificationDTO] = try await FirestoreService.request(NotificationsEndpoints.getNotifications(pet.id))
                    
                    return Pet(
                        id: pet.id,
                        image: image ?? Data() ,
                        name: pet.name,
                        breed: pet.breed,
                        type: AnimalType(rawValue: pet.type) ?? .dog,
                        birth: pet.birth.dateValue(),
                        colour: pet.colour,
                        weight: pet.weight,
                        weightUnit: pet.weightUnit,
                        gender: .male,
                        createdAt: pet.createdAt.dateValue(),
                        reminders: reminders.map { Self.mapPetNotification($0) }
                    )
                }
            }
            
            for try await pet in group {
                result.append(pet)
            }
            result.sort(by: { $1.createdAt < $0.createdAt })
            return result
        }
    }
}
