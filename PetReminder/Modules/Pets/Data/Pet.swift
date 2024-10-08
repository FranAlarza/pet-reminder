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
    let birth: Date
    let colour: String
    let gender: PetGender
}

enum PetGender: String, Codable, CaseIterable {
    case male, female
}

extension Pet: Equatable {
    static let sample: [Pet] =
    [
        .init(image: "dog_Example_Image", name: "Rex", breed: "Labrador Retriever", birth: .init(), colour: "Black", gender: .male),
        .init(image: "koala_Example_Image", name: "Mia", breed: "Koala", birth: .init(), colour: "White", gender: .female),
        .init(image: "monkey_Example_Image", name: "Tweety", breed: "Orangutan", birth: .init(), colour: "Yellow", gender: .male),
        .init(image: "rabbit_Example_Image", name: "Flipper", breed: "White Rabbit", birth: .init(), colour: "Orange", gender: .female),
        .init(image: "tejon_Example_Image", name: "Cafu", breed: "Tejon", birth: .init(), colour: "Green", gender: .male)
    ]
}
