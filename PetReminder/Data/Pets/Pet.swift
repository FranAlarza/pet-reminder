//
//  Pet.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import Foundation

struct Pet: Hashable, Identifiable {
    let id: String
    let image: Data
    let name: String
    let breed: String
    let type: AnimalType
    let birth: Date
    let colour: String
    let weight: Double
    let weightUnit: String
    let gender: PetGender
    let createdAt: Date
    
    var age: Int {
        Calendar.current
            .dateComponents(
                [.year],
                from: birth,
                to: Date()
            ).year ?? 0
    }
}

enum PetGender: String, Codable, CaseIterable {
    case male, female
}

enum AnimalType: String, Codable, CaseIterable {
    case dog, cat, bird, rabbit, fish, snake, reptile, turtle, other
}

extension Pet: Equatable {
    static let sample: [Pet] =
    [
        .init(
            id: UUID().uuidString,
            image: Data(),
            name: "Rex",
            breed: "Labrador Retriever",
            type: .dog,
            birth: .init(),
            colour: "Black",
            weight: 10,
            weightUnit: "kg",
            gender: .male,
            createdAt: Date()
        ),
        .init(
            id: UUID().uuidString,
            image: Data(),
            name: "Mia",
            breed: "Koala",
            type: .other,
            birth: .init(),
            colour: "White",
            weight: 10,
            weightUnit: "kg",
            gender: .female,
            createdAt: Date()
        ),
        .init(
            id: UUID().uuidString,
            image: Data(),
            name: "Tweety",
            breed: "Orangutan",
            type: .other,
            birth: .init(),
            colour: "Yellow",
            weight: 10,
            weightUnit: "kg",
            gender: .male,
            createdAt: Date()
        ),
        .init(
            id: UUID().uuidString,
            image: Data(),
            name: "Flipper",
            breed: "White Rabbit",
            type: .rabbit,
            birth: .init(),
            colour: "Orange",
            weight: 10,
            weightUnit: "kg",
            gender: .female,
            createdAt: Date()
        ),
        .init(
            id: UUID().uuidString,
            image: Data(),
            name: "Cafu",
            breed: "Tejon",
            type: .other,
            birth: .init(),
            colour: "Green",
            weight: 10,
            weightUnit: "kg",
            gender: .male,
            createdAt: Date()
        )
    ]
}
