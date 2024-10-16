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
    var petViewModel: PetViewModel = PetViewModel()
    
    @State
    var isAddPetFormPresented: Bool = false
    
    var body: some View {
        Group {
            switch petViewModel.petState {
            case .empty:
                VStack(spacing: 32) {
                    Image(systemName: "pawprint.fill")
                        .font(.title)
                    Text("No pets yet. Add one below.")
                }
            case .loading:
                LoadingView()
            case .loaded(let pets):
                List {
                    ForEach(pets) { pet in
                        PetRow(pet: pet)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task {
                                        await petViewModel.deletePet(pet: pet)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .overlay {
                                NavigationLink(value: pet, label: {})
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
        .animation(.easeInOut(duration: 1), value: petViewModel.petState)
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
            AddPetScreen()
                .environmentObject(petViewModel)
        })
        .navigationDestination(for: Pet.self) { pet in
            PetDetailScreen(pet: pet)
        }
    }
}

#Preview("Data") {
    NavigationStack {
        PetsScreen(petViewModel: PetViewModel(isTesting: true))
    }
}

#Preview("Empty") {
    NavigationStack {
        PetsScreen(petViewModel: PetViewModel(isTesting: true))
    }
}
