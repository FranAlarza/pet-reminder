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

    private var listeners: [ListenerRegistration] = []
    
    init(isTesting: Bool = false) {
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
