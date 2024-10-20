//
//  AnalitycsManager.swift
//  PetReminder
//
//  Created by Fran Alarza on 20/10/24.
//

import Foundation
import FirebaseAnalytics

final class AnalitycsManager {
    
    static let shared = AnalitycsManager()
    
    private init() {}
    
    func log(_ event: AnalitycsEvent) {
        var params: [String: Any] = [:]
        
        switch event {
        case .userDidLogin, .addAnimalOpen, .userDidLogout, .rateUs, .shakeOpen, .appActive, .appBackground, .appInactive, .registerLaunched, .loginLaunched:
            params = [:]
        case .animalCreated(let animal):
            params = animal.asDictionary()
        case .deleteAnimal(let animal):
            params = animal.asDictionary()
        }
        
        Analytics.logEvent(event.name, parameters: params)
        print("\n[Analytics] \nEvent: \(event.name)\nParams: \(params)")
    }
}

enum AnalitycsEvent {
    case appActive
    case appBackground
    case appInactive
    case userDidLogin
    case userDidLogout
    case animalCreated(AnimalAnalitycsEvent)
    case deleteAnimal(AnimalAnalitycsEvent)
    case addAnimalOpen
    case rateUs
    case shakeOpen
    case registerLaunched
    case loginLaunched
    
    var name: String {
        "\(self)"
    }
}

struct AnimalAnalitycsEvent: Encodable {
    let name: String
    let breed: String
    let age: Int
    let gender: String
    let weight: Double
    let createdAt: Date
}

extension AnimalAnalitycsEvent {
    init(animal: Animal) {
        name = animal.name
        breed = animal.breed
        age = animal.age
        gender = animal.gender.rawValue
        weight = animal.weight
        createdAt = animal.createdAt
    }
}

