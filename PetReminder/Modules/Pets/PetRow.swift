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
                .frame(width: 150, height: 150)
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
        VStack(alignment: .leading) {
            Text("\(pet.name), \(pet.age)")
                .font(.system(.title))
            Text(pet.breed)
                .font(.system(.subheadline, weight: .light))
            Text(pet.type.rawValue)
                .font(.system(.subheadline, weight: .light))
            Text(pet.colour)
                .font(.system(.subheadline, weight: .light))
        }
        .foregroundStyle(.primary)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    PetRow(
        pet: .init(
            image: Data(),
            name: "Daisy",
            breed: "Podenco",
            type: .dog,
            birth: .now,
            colour: "red",
            gender: .female
        )
    )
}
