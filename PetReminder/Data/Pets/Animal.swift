//
//  Animal.swift
//  PetReminder
//
//  Created by Fran Alarza on 16/10/24.
//

import Foundation

struct Animal: Hashable, Identifiable {
    var id: String = UUID().uuidString
    var imagePath: String = ""
    var image: String = ""
    var name: String = "Daisy"
    var breed: String = "Podenco"
    var type: AnimalType = .other
    var birth: Date = Date()
    var colour: String = "Canela"
    var weight: Double = 0.0
    var weightUnit: String = ""
    var gender: PetGender = .male
    var createdAt: Date = Date()
    var notifications: [Notification] = []
    
    var age: Int {
        Calendar.current
            .dateComponents(
                [.year],
                from: birth,
                to: Date()
            ).year ?? 0
    }
}

extension Animal {
    init(dto: AnimalDTO) {
        id = dto.id
        imagePath = dto.image
        image = dto.image
        name = dto.name
        breed = dto.breed
        type = dto.type
        birth = dto.birth.dateValue()
        colour = dto.colour
        weight = dto.weight
        weightUnit = dto.weightUnit
        gender = dto.gender
        createdAt = dto.createdAt.dateValue()
        notifications = []
    }
}
