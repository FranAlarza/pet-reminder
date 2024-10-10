//
//  AuthEndpoints.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation

struct RegisterDto: FirestoreIdentifiable {
    var id: String
}

enum AuthEndpoints: FirestoreEndpoint {
    case register(RegisterDto)
    
    var path: FirestoreReference {
        switch self {
        case .register(let dto):
            return firestore.collection("users").document(dto.id)
        }
    }
    
    var method: FirestoreMethod {
        switch self {
        case .register(let dto):
            return .post(dto)
        }
    }
}
