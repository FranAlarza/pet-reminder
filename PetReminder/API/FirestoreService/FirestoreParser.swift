//
//  FirestoreParser.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation

struct FirestoreParser {
    static func parse<T: Decodable>(_ documentData: Dictionary, type: T.Type) throws -> T {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: jsonData)
        } catch {
            throw error
        }
    }
}
