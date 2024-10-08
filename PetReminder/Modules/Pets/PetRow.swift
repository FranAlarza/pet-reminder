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
            Image(pet.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 16, height: 16)))
            petAttributes
        }
        .background(
            RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5) // Apply shadow here
        )
    }
    
    var petAttributes: some View {
        VStack(alignment: .leading) {
            Text(pet.name)
                .font(.system(.title))
            Text(pet.breed)
                .font(.system(.subheadline))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PetRow(
        pet: .init(
            image: "dog_Example_Image",
            name: "Daisy",
            breed: "Podenco",
            birth: .now,
            colour: "red",
            gender: .female
        )
    )
}
