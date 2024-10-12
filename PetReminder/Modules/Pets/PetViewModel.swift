//
//  PetViewModel.swift
//  PetReminder
//
//  Created by Fran Alarza on 12/10/24.
//

import SwiftUI

@MainActor
final class PetViewModel: ObservableObject {
    
    @Published var petState: PetScreenState = .loading

    init() {
        Task {
            await getPets()
        }
    }
    
    func getPets() async {
        petState = .loading
        do {
            let pets: [PetDTO] = try await FirestoreService.request(PetsEndpoints.getPets)
            let mappedPets = await mapPets(pets)
            petState = pets.isEmpty ? .empty : .loaded(mappedPets)
            print("Successfully fetched pets with state: \(petState)")
        } catch {
            petState = .error
            print("Error fetching pets: \(error.localizedDescription)")
        }
    }
    
    func mapPets(_ pets: [PetDTO]) async -> [Pet] {
        return await withTaskGroup(of: Pet.self, returning: [Pet].self) { group in
            var result: [Pet] = []
            
            for pet in pets {
                group.addTask {
                    let image = await FirestoreService.downloadImage(pet.image)
                    
                    return Pet(
                        image: image ?? Data() ,
                        name: pet.name,
                        breed: pet.breed,
                        type: AnimalType(rawValue: pet.type) ?? .dog,
                        birth: pet.birth.dateValue(),
                        colour: pet.colour,
                        gender: .male
                    )
                }
            }
            
            for await pet in group {
                result.append(pet)
            }
            
            return result
        }
    }
}
