//
//  AnimalDTO.swift
//  PetReminder
//
//  Created by Fran Alarza on 16/10/24.
//

import Foundation
import FirebaseCore

struct AnimalDTO: FirestoreIdentifiable {
    var id: String
    var image: String
    let name: String
    let breed: String
    let type: AnimalType
    let colour: String
    let birth: Timestamp
    let weight: Double
    let weightUnit: String
    let gender: PetGender
    let createdAt: Timestamp
}

extension AnimalDTO {
    init(animal: Animal) {
        id = animal.id
        image = animal.image
        name = animal.name
        breed = animal.breed
        type = animal.type
        colour = animal.colour
        birth = Timestamp(date: animal.birth)
        weight = animal.weight
        weightUnit = animal.weightUnit
        gender = animal.gender
        createdAt = Timestamp(date: animal.createdAt) 
    }
}

enum PetGender: String, Codable, CaseIterable {
    case male, female
}

enum AnimalType: String, Codable, CaseIterable {
    case dog, cat, bird, rabbit, fish, snake, reptile, turtle, other
}

