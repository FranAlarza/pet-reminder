//
//  Pet.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import Foundation

struct Pet: Hashable, Identifiable {
    var id: UUID = .init()
    let image: String
    let name: String
    let breed: String
    let type: AnimalType
    let birth: Date
    let colour: String
    let gender: PetGender
    
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
            image: "dog_Example_Image",
            name: "Rex",
            breed: "Labrador Retriever",
            type: .dog,
            birth: .init(),
            colour: "Black",
            gender: .male
        ),
        .init(
            image: "koala_Example_Image",
            name: "Mia",
            breed: "Koala",
            type: .other,
            birth: .init(),
            colour: "White",
            gender: .female
        ),
        .init(
            image: "monkey_Example_Image",
            name: "Tweety",
            breed: "Orangutan",
            type: .other,
            birth: .init(),
            colour: "Yellow",
            gender: .male
        ),
        .init(
            image: "rabbit_Example_Image",
            name: "Flipper",
            breed: "White Rabbit",
            type: .rabbit,
            birth: .init(),
            colour: "Orange",
            gender: .female
        ),
        .init(
            image: "tejon_Example_Image",
            name: "Cafu",
            breed: "Tejon",
            type: .other,
            birth: .init(),
            colour: "Green",
            gender: .male
        )
    ]
}
