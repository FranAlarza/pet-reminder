//
//  PetsScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI

enum ScreenState<T: Equatable>: Equatable {
    case loaded([T])
    case loading
    case error
    case empty
}

struct PetsScreen: View {
    
    @StateObject
    var animalViewModel = AnimalViewModel()
    
    @State
    var isAddPetFormPresented: Bool = false
    
    var body: some View {
        Group {
            switch animalViewModel.animalState {
            case .empty:
                VStack(spacing: 32) {
                    Image(systemName: "pawprint.fill")
                        .font(.title)
                    Text("No pets yet. Add one below.")
                }
            case .loading:
                LoadingView()
            case .loaded(let animals):
                List {
                    ForEach(animals) { animal in
                        AnimalRow(animal: animal)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task {
                                        await animalViewModel.deleteAnimal(animal)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .overlay {
                                NavigationLink(value: animal, label: {})
                                    .opacity(0)
                            }
                        
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(8)
                case .error:
                Text("Error loading pets.")
            case .none:
                EmptyView()
            }
        }
        .animation(.easeInOut(duration: 1), value: animalViewModel.animalState)
        .navigationTitle("Pets")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isAddPetFormPresented.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
        })
        .fullScreenCover(isPresented: $isAddPetFormPresented, content: {
            AddAnimalScreen(mode: .add, action: {_ in})
                .environmentObject(animalViewModel)
        })
        .navigationDestination(for: Animal.self) { animal in
            AnimalDetailScreen(animal: animal, viewModel: animalViewModel)
        }
    }
}

#Preview("Data") {
    NavigationStack {
        PetsScreen()
    }
}

#Preview("Empty") {
    NavigationStack {
        PetsScreen()
    }
}
