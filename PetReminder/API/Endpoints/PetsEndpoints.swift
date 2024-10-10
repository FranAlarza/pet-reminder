//
//  PetsEndpoints.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth

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

enum PetsEndpoints: FirestoreEndpoint {
    case getPets
    case postPet(dto: PetDTO)
    
    var path: FirestoreReference {
        switch self {
        case .getPets:
            guard let uid = Global.userId else { return firestore.collection("pets") }
            return firestore.collection("users/\(uid)/pets")
        case .postPet(let dto):
            guard let uid = Global.userId else { return firestore.collection("pets") }
            return firestore.collection("users/\(uid)/pets").document(dto.id)
        }
    }
    
    var method: FirestoreMethod {
        switch self {
            case .getPets:
            return .get
        case .postPet(let dto):
            return .post(dto)
        }
    }
}
