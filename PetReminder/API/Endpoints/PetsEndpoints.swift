//
//  PetsEndpoints.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth

enum PetsEndpoints: FirestoreEndpoint {
    case getPets
    case postPet(dto: PetDTO)
    case deletePet(id: String)
    
    var path: FirestoreReference {
        guard let uid = Global.userId else { return firestore.collection("pets") }
        
        switch self {
        case .getPets:
            return firestore.collection("users/\(uid)/pets")
        case .postPet(let dto):
            return firestore.collection("users/\(uid)/pets").document(dto.id)
        case .deletePet(let id):
            return firestore.collection("users/\(uid)/pets").document(id)
        }
    }
    
    var method: FirestoreMethod {
        switch self {
            case .getPets:
            return .get
        case .postPet(let dto):
            return .post(dto)
        case .deletePet:
            return .delete
        }
    }
}
