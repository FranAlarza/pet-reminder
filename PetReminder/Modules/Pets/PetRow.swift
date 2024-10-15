//
//  PetRow.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI

struct PetRow: View {
    let pet: Pet
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: UIImage(data: pet.image) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
            petAttributes
        }
        .background(
            RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                .fill(Color(.systemBackground))
                .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 2)
        )
    }
    
    var petAttributes: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(pet.name), \(pet.age)")
                .font(.system(size: 18, weight: .bold))
            generateAttributeLine(name: "Breed:", attribute: pet.breed)
            generateAttributeLine(name: "Type:", attribute: pet.type.rawValue)
            generateAttributeLine(name: "Color:", attribute: pet.colour)

            HStack {
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.attributesText)
                Text("\(pet.reminders.count)")
                    .foregroundStyle(.gray)
            }
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    func generateAttributeLine(name: String, attribute: String) -> some View {
        HStack {
            Text(name)
                .bold()
            Text(attribute)
        }
        .font(.system(.subheadline, weight: .light))
    }
}

#Preview {
    PetRow(
        pet:  .init(
            id: UUID().uuidString,
            image: Data(),
            name: "Cafu",
            breed: "Tejon",
            type: .other,
            birth: .init(),
            colour: "Green",
            weight: 10,
            weightUnit: "kg",
            gender: .male,
            createdAt: Date(),
            reminders: []
        )
    )
}
