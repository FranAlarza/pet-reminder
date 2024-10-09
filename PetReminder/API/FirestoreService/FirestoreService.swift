//
//  FirestoreService.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation
import FirebaseFirestore

public protocol FirestoreServicProtocol {
    static func request<T: FirestoreIdentifiable>(_ endpoint: FirestoreEndpoint) async throws -> T
    static func request<T: FirestoreIdentifiable>(_ endpoint: FirestoreEndpoint) async throws -> [T]
    static func request(_ endpoint: FirestoreEndpoint) async throws -> Void
}

public final class FirestoreService: FirestoreServicProtocol {

    private init() {}
    
    public static func request<T>(_ endpoint: any FirestoreEndpoint) async throws -> T where T : FirestoreIdentifiable {
        guard let ref = endpoint.path as? DocumentReference else {
            throw FirestoreServiceError.documentNotFound
        }
        
        switch endpoint.method {
        case .get:
            guard let documentSnapshot = try? await ref.getDocument() else {
                throw FirestoreServiceError.invalidPath
            }
            
            guard let documentData = documentSnapshot.data() else {
                throw FirestoreServiceError.parseError
            }
            
            let singleResponse = try FirestoreParser.parse(documentData, type: T.self)
            return singleResponse
        default :
            throw FirestoreServiceError.invalidRequest
        }
    }
    
    public static func request<T>(_ endpoint: any FirestoreEndpoint) async throws -> [T] where T : FirestoreIdentifiable {
        guard let ref = endpoint.path as? CollectionReference else {
            throw FirestoreServiceError.collectionNotFound
        }
        switch endpoint.method {
        case .get:
            let querySnapshot = try await ref.getDocuments()
            var response: [T] = []
            for document in querySnapshot.documents {
                let data = try FirestoreParser.parse(document.data(), type: T.self)
                response.append(data)
            }
            return response
        case .post, .put, .delete:
            throw FirestoreServiceError.operationNotSupported
        }
    }
    
    public static func request(_ endpoint: any FirestoreEndpoint) async throws {
        guard let ref = endpoint.path as? DocumentReference else {
            throw FirestoreServiceError.documentNotFound
        }
        switch endpoint.method {
        case .get:
            throw FirestoreServiceError.invalidRequest
        case .post(var model):
            model.id = ref.documentID
            try await ref.setData(model.asDictionary())
        case .put(let model):
            try await ref.setData(model.asDictionary())
        case .delete:
            try await ref.delete()
        }
    }
}
