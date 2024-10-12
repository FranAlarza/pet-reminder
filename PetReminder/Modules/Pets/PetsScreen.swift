//
//  PetsScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI

enum PetScreenState: Equatable {
    case loaded([Pet])
    case loading
    case error
    case empty
}

struct PetsScreen: View {
    
    @ObservedObject
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
                ZStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(3)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black.opacity(0.5))
                
            case .loaded(let pets):
                List {
                    ForEach(pets) { pet in
                        NavigationLink(value: pet, label: {
                            PetRow(pet: pet)
                                .swipeActions {
                                    Button(action: {}) {
                                        Image(systemName: "trash")
                                    }
                                }
                                .listRowSeparator(.hidden)
                        })
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(8)
                case .error:
                Text("Error loading pets.")
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
        })
        .navigationDestination(for: Pet.self) { pet in
            PetDetailScreen(pet: pet)
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
