//
//  PetsScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI

enum PetScreenState: CaseIterable {
    case loaded
    case loading
    case error
}

struct PetsScreen: View {
    @State
    var isAddPetFormPresented: Bool = false
    @State var pets: [Pet] = []
    
    var body: some View {
        Group {
            if pets.isEmpty {
                VStack(spacing: 32) {
                    Image(systemName: "pawprint.fill")
                        .font(.title)
                    Text("No pets yet. Add one below.")
                }
            } else {
                List {
                    ForEach(pets) { pet in
                        PetRow(pet: pet)
                            .swipeActions {
                                Button(action: {}) {
                                    Image(systemName: "trash")
                                }
                            }
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(16)
            }
        }
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
            AddPetFormScreen()
        })
    }
}

#Preview("Data") {
    NavigationStack {
        PetsScreen(pets: Pet.sample)
    }
}

#Preview("Empty") {
    NavigationStack {
        PetsScreen()
    }
}
