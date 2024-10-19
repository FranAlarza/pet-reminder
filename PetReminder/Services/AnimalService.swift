//
//  AnimalService.swift
//  PetReminder
//
//  Created by Fran Alarza on 17/10/24.
//

import Foundation

protocol AnimalServiceProtocol {
    func getAnimalsWithReminders() async throws -> [Animal]
    func addAnimal(_ animal: Animal) async throws
    func deleteAnimal(_ animal: Animal) async throws
}

final class AnimalService: AnimalServiceProtocol {
    
    private let animalRepository: AnimalRepositoryProtocol
    private let notificationsRepository: NotificationRepository
    
    init(
        animalRepository: AnimalRepositoryProtocol = AnimalRepository(),
        notificationsRepository: NotificationRepository = NotificationRepository()
    ) {
        self.animalRepository = animalRepository
        self.notificationsRepository = notificationsRepository
    }
    
    func getAnimalsWithReminders() async throws -> [Animal] {
        try await animalRepository.getAnimalsWithReminders()
    }
    
    func addAnimal(_ animal: Animal) async throws {
        try await animalRepository.addAnimal(animal)
    }
    
    func deleteAnimal(_ animal: Animal) async throws {
        try await animalRepository.delete(animal)
    }
}
