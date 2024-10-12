//
//  PetDetailScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 12/10/24.
//

import SwiftUI

struct PetDetailScreen: View {
    let pet: Pet
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                VStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                    Spacer()
                }
                infoCard
                    .offset(x: 0, y: -proxy.size.height * 0.5)
                    .padding(.horizontal, 32)
                    .zIndex(150)
                infoSheet
                    .frame(height: proxy.size.height * 0.55)
                    .zIndex(100)

            }
        }
    }
    
    var image: Image {
        if let image = UIImage(data: pet.image) {
            return Image(uiImage: image)
        } else {
            return Image(systemName: "person.crop.circle.fill")
        }
    }
    
    var infoCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(pet.name)
                .font(.title)
            Text(pet.breed)
                .font(.subheadline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(32)
        .background {
            RoundedRectangle(cornerSize: CGSize(width: 48, height: 48))
                .fill(Color(.systemBackground))
                .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 2)
        }
    }
    
    var infoSheet: some View {
        VStack {
            Spacer()
            VStack(spacing: 32) {
                HStack(spacing: 12) {
                    attributeCard(title: "Age", value: "\(pet.age)")
                    attributeCard(title: "Gender", value: "\(pet.gender.rawValue.capitalized)")
                    attributeCard(title: "Colour", value: "\(pet.colour)")
                    attributeCard(title: "Lenght", value: "9")
                }
                Divider()
                    .background(.attributesText)
                    .padding(.horizontal, 16)
                Spacer()
            }
            .padding(.top, 64)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerSize: CGSize(width: 36, height: 36))
                    .fill(Color(.detailSheet))
            }
        }
        .ignoresSafeArea()
    }
    
    func attributeCard(title: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .bold()
            Text(value)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerSize: CGSize(width: 48, height: 48))
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 2)
                }
                .foregroundStyle(.attributesText)
        }
    }
}

#Preview {
    PetDetailScreen(
        pet: .init(
            image: Data(),
            name: "Daisy",
            breed: "Podenco",
            type: .dog,
            birth: Date(),
            colour: "Canela",
            gender: .male
        )
    )
}
