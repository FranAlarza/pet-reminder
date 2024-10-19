//
//  AnimalRepository.swift
//  PetReminder
//
//  Created by Fran Alarza on 16/10/24.
//

import Foundation
import UIKit

protocol AnimalRepositoryProtocol {
    func getAnimalsWithReminders() async throws -> [Animal]
    func addAnimal(_ pet: Animal) async throws
    func edit(pet: Animal)
    func delete(_ animal: Animal) async throws
    func subscribe(to pet: Animal, completion: @escaping (Result<Animal, Error>) -> Void)
}

final class AnimalRepository: AnimalRepositoryProtocol {
    
    func getAnimalsWithReminders() async throws -> [Animal] {
        let animalsDTO: [AnimalDTO] = try await FirestoreService.request(PetsEndpoints.getPets)
        
        var animals: [Animal] = []
        
        try await withThrowingTaskGroup(of: Animal.self) { group in
            for animal in animalsDTO {
                group.addTask {
                    var animal = Animal(dto: animal)
                    let reminders: [NotificationDTO] = try await FirestoreService.request(NotificationsEndpoints.getNotifications(animal.id))
                    let image = await FirestoreService.downloadImage(animal.image)
                    
                    animal.notifications = reminders.map { Notification(dto: $0) }
                    if let image, let imageBase64 = UIImage(data: image)?.convertImageToBase64String() {
                        animal.image = imageBase64
                    }
                    return animal
                }
            }
            
            for try await animal in group {
                animals.append(animal)
            }
        }
       
        return animals
    }
    
    func addAnimal(_ pet: Animal) async throws {
        let animalURL = try await FirestoreService.uploadImage(pet.image.imageFromBase64())
        var animalDTO: AnimalDTO = .init(animal: pet)
        animalDTO.image = animalURL ?? ""
        try await FirestoreService.request(PetsEndpoints.postPet(dto: animalDTO))
    }
    
    func edit(pet: Animal) {
        //
    }
    
    func delete(_ animal: Animal) async throws {
        try await withThrowingTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {
                try await FirestoreService.deleteImage(animal.imagePath)
            }
            taskGroup.addTask {
                try await FirestoreService.request(PetsEndpoints.deletePet(id: animal.id))
            }
            try await taskGroup.waitForAll()
        }
    }
    
    func subscribe(to pet: Animal, completion: @escaping (Result<Animal, any Error>) -> Void) {
        //
    }
    
    
}
