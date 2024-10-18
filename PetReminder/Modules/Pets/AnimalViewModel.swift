//
//  AnimalViewModel.swift
//  PetReminder
//
//  Created by Fran Alarza on 12/10/24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class AnimalViewModel: ObservableObject {
    
    @Published var animalState: ScreenState<Animal>?

    private let notificationService: NotificationServiceProtocol
    private let animalService: AnimalServiceProtocol
    private var listeners: [ListenerRegistration] = []
    
    init(
        notificationService: NotificationServiceProtocol = NotificationService(),
        animalService: AnimalServiceProtocol = AnimalService()
    ) {
        self.notificationService = notificationService
        self.animalService = animalService
        Task {
            try await getAnimals()
        }
    }
    
    deinit {
        listeners.forEach { $0.remove() }
    }
    
    func setAnimalState(animals: [Animal]) {
        animalState = animals.isEmpty ? .empty : .loaded(animals)
        print("Successfully subscribed to pets with state: \(String(describing: animalState))")
    }
    
    func addAnimalWithReminders(animal: Animal) async throws {
        try await animalService.addAnimal(animal)
        try await addReminders(notifications: animal.notifications, animalId: animal.id)
        try await getAnimals()
    }
    
    func editAnimalWithReminders(animal: Animal) async throws {
        try await animalService.deleteAnimal(animal)
        try await notificationService.removeAllNotifications(animalId: animal.id)
        try await addAnimalWithReminders(animal: animal)
    }
    
    func getAnimals() async throws {
        do {
            let animals = try await animalService.getAnimalsWithReminders()
            setAnimalState(animals: animals)
        } catch {
            animalState = .error
            print("Error getting pets: \(error)")
        }
        
    }
    
    func deleteAnimal(_ animal: Animal) async {
        do {
            try await animalService.deleteAnimal(animal)
            try await deleteAnimalNotifications(notifications: animal.notifications, petId: animal.id)
            try await getAnimals()
            print("Successfully removed pet")
        } catch {
            print("Error removing pet: \(error)")
        }
    }
    
//    func suscribeToPets() {
//        let subscription = FirestoreService.subscribe(PetsEndpoints.getPets) { [weak self] (result: Result<[PetDTO], FirestoreServiceError>) in
//            self?.petState = .loading
//            switch result {
//            case .success(let items):
//                Task {
//                    await self?.setPetState(items: items)
//                }
//            case .failure(let error):
//                self?.petState = .empty
//                print("Error subscribing to pets: \(error)")
//            }
//        }
//        
//        if let subscription {
//            listeners.append(subscription)
//        }
//    }
}

private extension AnimalViewModel {
    
    func addReminders(notifications: [Notification], animalId: String) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for notification in notifications {
                group.addTask {
                    try await self.notificationService.scheduleNotificationWithAditionalNotification(notification: notification, animalId: animalId)
                }
            }
            try await group.waitForAll()
        }
    }

    func deleteAnimalNotifications(notifications: [Notification], petId: String) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for notification in notifications {
                group.addTask {
                    try await self.notificationService.removeNotification(animalId: petId, notificationId: notification.id)
                }
            }
            try await group.waitForAll()
        }
    }
}
