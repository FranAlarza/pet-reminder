//
//  PetDTO.swift
//  PetReminder
//
//  Created by Fran Alarza on 10/10/24.
//

import Foundation
import FirebaseFirestore

struct PetDTO: FirestoreIdentifiable {
    var id: String
    let image: String
    let name: String
    let breed: String
    let type: String
    let colour: String
    let birth: Timestamp
    let weight: Double
    let weightUnit: String
    let gender: PetGender
    let createdAt: Timestamp
    
    init(
        id: String = UUID().uuidString,
        image: String,
        name: String,
        breed: String,
        type: String,
        colour: String,
        birth: Timestamp,
        weight: Double,
        weightUnit: String,
        gender: PetGender,
        createdAt: Timestamp = .init()
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.breed = breed
        self.type = type
        self.colour = colour
        self.birth = birth
        self.weight = weight
        self.weightUnit = weightUnit
        self.gender = gender
        self.createdAt = createdAt
    }
}
