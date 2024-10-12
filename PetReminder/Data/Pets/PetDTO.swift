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
    
    init(
        id: String = UUID().uuidString,
        image: String,
        name: String,
        breed: String,
        type: String,
        colour: String,
        birth: Timestamp
    ) {
        self.id = id
        self.image = image
        self.name = name
        self.breed = breed
        self.type = type
        self.colour = colour
        self.birth = birth
    }
}
