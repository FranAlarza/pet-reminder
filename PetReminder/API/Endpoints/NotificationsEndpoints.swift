//
//  NotificationsEndpoints.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation

enum NotificationsEndpoints: FirestoreEndpoint {
    case getNotifications(String)
    case postNotifications(PetNotificationDTO, String)
    
    var path: FirestoreReference {
        switch self {
        case .getNotifications(let petId):
            guard let uid = Global.userId else { return firestore.collection("pets") }
            return firestore.collection("users/\(uid)/pets/\(petId)/reminders")
        case .postNotifications(let dto, let petId):
            guard let uid = Global.userId else { return firestore.collection("pets") }
            return firestore.collection("users/\(uid)/pets/\(petId)/reminders").document(dto.id)
        }
    }
    
    var method: FirestoreMethod {
        switch self {
            case .getNotifications:
            return .get
        case .postNotifications(let dto, _):
            return .post(dto)
        }
    }
}
