//
//  FirestoreIdentifiable.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation

public typealias Dictionary = [String: Any]

public protocol FirestoreIdentifiable: Hashable, Codable, Identifiable {
    var id: String { get set }
}

extension Encodable {
    
    func asDictionary() -> Dictionary {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? Dictionary else {
            return [:]
        }
        
        return dictionary
    }
}
