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
    case deleteReminders(String, String)
    
    var path: FirestoreReference {
        switch self {
        case .getNotifications(let petId):
            guard let uid = Global.userId else { return firestore.collection("pets") }
            return firestore.collection("users/\(uid)/pets/\(petId)/reminders")
        case .postNotifications(let dto, let petId):
            guard let uid = Global.userId else { return firestore.collection("pets") }
            return firestore.collection("users/\(uid)/pets/\(petId)/reminders").document(dto.id)
        case .deleteReminders(let petId, let id):
            guard let uid = Global.userId else { return firestore.collection("pets") }
            return firestore.collection("users/\(uid)/pets/\(petId)/reminders").document(id)
        }
    }
    
    var method: FirestoreMethod {
        switch self {
            case .getNotifications:
            return .get
        case .postNotifications(let dto, _):
            return .post(dto)
        case .deleteReminders:
            return .delete
        }
    }
}
