//
//  FirestoreService.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

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
    
    public static func uploadImage(_ image: UIImage?) async throws -> String? {
        guard let image else {
            print("[FirestoreService] - \(#function) not image found")
            return nil
        }
        
        let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            print("[FirestoreService] - \(#function) not image quality")
            return nil
        }
        
        let metaData = try await storageRef.putDataAsync(imageData)

        return metaData.path
    }
    
    public static func downloadImage(_ url: String) async -> Data? {
        return await withCheckedContinuation { continuation in
            let storageRef = Storage.storage().reference(withPath: url)
            
            storageRef.getData(maxSize: 4 * 1024 * 1024) { result in
                switch result {
                case .success(let data):
                    print("Image downloaded successfully")
                    continuation.resume(returning: data)
                case .failure(let error):
                    print("Error downloading image \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    // MARK: - Try to convert to async await with async stream maybe
    public static func subscribe<T>(_ endpoint: any FirestoreEndpoint, onUpdate: @escaping (Result<[T], FirestoreServiceError>) -> Void) -> ListenerRegistration? where T: FirestoreIdentifiable {
        guard let ref = endpoint.path as? CollectionReference else {
            onUpdate(.failure(.collectionNotFound))
            return nil
        }
        
        let listener = ref.addSnapshotListener { querySnapshot, error in
            if let error = error {
                onUpdate(.failure(.operationNotSupported))
                print("Error subscribing to collection: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                onUpdate(.failure(.parseError))
                return
            }
            
            var response: [T] = []
            for document in documents {
                do {
                    let data = try FirestoreParser.parse(document.data(), type: T.self)
                    response.append(data)
                } catch {
                    onUpdate(.failure(.parseError))
                    return
                }
            }
            
            onUpdate(.success(response))
        }
        
        return listener
    }

}
