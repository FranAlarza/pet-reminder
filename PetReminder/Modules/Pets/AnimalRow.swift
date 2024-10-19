//
//  AnimalRow.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI

struct AnimalRow: View {
    let animal: Animal
    var body: some View {
        HStack(alignment: .top) {
            Image(uiImage: animal.image.imageFromBase64() ?? UIImage())
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
            Text("\(animal.name), \(animal.age)")
                .font(.system(size: 18, weight: .bold))
            generateAttributeLine(name: "Breed:", attribute: animal.breed)
            generateAttributeLine(name: "Type:", attribute: animal.type.rawValue)
            generateAttributeLine(name: "Color:", attribute: animal.colour)

            HStack {
                Image(systemName: "bell.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.attributesText)
                Text("\(animal.notifications.count)")
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
    AnimalRow(
        animal:  .init(
            id: UUID().uuidString,
            image: "",
            name: "Cafu",
            breed: "Tejon",
            type: .other,
            birth: .init(),
            colour: "Green",
            weight: 10,
            weightUnit: "kg",
            gender: .male,
            createdAt: Date(),
            notifications: []
        )
    )
}
