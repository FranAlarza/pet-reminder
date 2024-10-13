//
//  PetViewModel.swift
//  PetReminder
//
//  Created by Fran Alarza on 12/10/24.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class PetViewModel: ObservableObject {
    
    @Published var petState: ScreenState<Pet>?

    private let notificationManager: NotificationManagerProtocol
    private var listeners: [ListenerRegistration] = []
    
    init(
        notificationManager: NotificationManagerProtocol = NotificationManager(),
        isTesting: Bool = false
    ) {
        self.notificationManager = notificationManager
        if isTesting {
            petState = .loading
            petState = .loaded(Pet.sample)
        } else {
            suscribeToPets()
        }
    }
    
    deinit {
        listeners.forEach { $0.remove() }
    }
    
    func suscribeToPets() {
        let subscription = FirestoreService.subscribe(PetsEndpoints.getPets) { [weak self] (result: Result<[PetDTO], FirestoreServiceError>) in
            self?.petState = .loading
            switch result {
            case .success(let items):
                Task {
                    let mappedPets: [Pet] = await self?.mapPets(items) ?? []
                    self?.petState = items.isEmpty ? .empty : .loaded(mappedPets)
                    print("Successfully subscribed to pets with state: \(String(describing: self?.petState))")
                }
            case .failure(let error):
                self?.petState = .error
                print("Error subscribing to pets: \(error.localizedDescription)")
            }
        }
        
        if let subscription {
            listeners.append(subscription)
        }
    }
    
    func addPet(pet: PetDTO, reminders: [PetNotificationDTO], inputImage: UIImage) async throws {
        let url = try await FirestoreService.uploadImage(inputImage) ?? ""
        let dto: PetDTO = .init(
            image: url,
            name: pet.name,
            breed: pet.breed,
            type: pet.type,
            colour: pet.colour,
            birth: pet.birth,
            weight: pet.weight,
            weightUnit: pet.weightUnit,
            gender: pet.gender
        )
        try await FirestoreService.request(PetsEndpoints.postPet(dto: dto))
        try await addReminders(reminders: reminders, petId: dto.id)
    }
    
    func addReminders(reminders: [PetNotificationDTO], petId: String) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for reminder in reminders {
                group.addTask {
                    try await FirestoreService.request(NotificationsEndpoints.postNotifications(reminder, petId))
                }
            }
            
            try await group.waitForAll()
        }
        
    }
    
    func addNotification(pet: PetNotification) async {
        do {
            try await notificationManager.scheduleNotificationWithAditionalNotification(notification: pet)
            print("Notification added successfully")
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func mapPets(_ pets: [PetDTO]) async -> [Pet] {
        return await withTaskGroup(of: Pet.self, returning: [Pet].self) { group in
            var result: [Pet] = []
            
            for pet in pets {
                group.addTask {
                    let image = await FirestoreService.downloadImage(pet.image)
                    
                    return Pet(
                        id: pet.id,
                        image: image ?? Data() ,
                        name: pet.name,
                        breed: pet.breed,
                        type: AnimalType(rawValue: pet.type) ?? .dog,
                        birth: pet.birth.dateValue(),
                        colour: pet.colour,
                        weight: pet.weight,
                        weightUnit: pet.weightUnit,
                        gender: .male,
                        createdAt: pet.createdAt.dateValue()
                    )
                }
            }
            
            for await pet in group {
                result.append(pet)
            }
            result.sort(by: { $1.createdAt < $0.createdAt })
            return result
        }
    }
}
