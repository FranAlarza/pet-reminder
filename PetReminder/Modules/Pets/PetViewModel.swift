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
    
    func setPetState(items: [PetDTO]) async {
        do {
            let mappedPets: [Pet] = try await Mappers.mapPets(items)
            petState = items.isEmpty ? .empty : .loaded(mappedPets)
            print("Successfully subscribed to pets with state: \(String(describing: petState))")
        } catch {
            print("Error mapping pets: \(error.localizedDescription)")
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
    
    func suscribeToPets() {
        let subscription = FirestoreService.subscribe(PetsEndpoints.getPets) { [weak self] (result: Result<[PetDTO], FirestoreServiceError>) in
            self?.petState = .loading
            switch result {
            case .success(let items):
                Task {
                    await self?.setPetState(items: items)
                }
            case .failure(let error):
                self?.petState = .empty
                print("Error subscribing to pets: \(error)")
            }
        }
        
        if let subscription {
            listeners.append(subscription)
        }
    }
    
    
    func getRemainders(petId: String) async -> [PetNotificationDTO] {
        do {
            let reminders: [PetNotificationDTO] = try await FirestoreService.request(NotificationsEndpoints.getNotifications(petId))
            print("Successfully retrieved reminders")
            return reminders
        } catch {
            print("Error retrieving reminders: \(error)")
            return []
        }
    }
    
    func addNotification(pet: PetNotification) async {
        do {
            try await notificationManager.scheduleNotificationWithAditionalNotification(notification: pet)
            print("Notification added successfully")
        } catch {
            print("error: \(error)")
        }
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
    
    func deleteNotification(notificationId: String) {
        notificationManager.removeNotification(with: notificationId)
        print("Notification deleted successfully")
    }
}
