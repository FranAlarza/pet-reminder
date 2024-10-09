//
//  FirestoreServiceError.swift
//  PetReminder
//
//  Created by Fran Alarza on 9/10/24.
//

import Foundation

public enum FirestoreServiceError: Error {
    case invalidPath
    case invalidType
    case collectionNotFound
    case documentNotFound
    case unknownError
    case parseError
    case invalidRequest
    case operationNotSupported
    case invalidQuery
    case operationNotAllowed
}
