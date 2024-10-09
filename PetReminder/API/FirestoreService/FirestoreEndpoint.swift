//
//  FirestoreEndpoint.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation
import FirebaseFirestore

public typealias FirestoreQuery = Query

public protocol FirestoreEndpoint {
    var path: FirestoreReference { get }
    var method: FirestoreMethod { get }
    var firestore: Firestore { get }
}

public extension FirestoreEndpoint {
    var firestore: Firestore { Firestore.firestore() }
}

public enum FirestorePath {
    case collection(reference: CollectionReference)
    case document(reference: DocumentReference)
}

public enum FirestoreMethod {
    case get
    case post(any FirestoreIdentifiable)
    case put(any FirestoreIdentifiable)
    case delete
}

public protocol FirestoreReference {
    // You can define common methods/properties here, if needed
}

extension DocumentReference: FirestoreReference { }
extension CollectionReference: FirestoreReference { }


