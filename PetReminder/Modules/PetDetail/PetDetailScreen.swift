//
//  PetDetailScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 12/10/24.
//

import SwiftUI

struct PetDetailScreen: View {
    let pet: Pet
    @State var isAddPetSheetOpen: Bool = false
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                VStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: proxy.size.height * 0.4)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "pencil.circle.fill")
                        .foregroundStyle(.attributesText)
                        .onTapGesture {
                            isAddPetSheetOpen.toggle()
                        }
                }
            }
            .sheet(isPresented: $isAddPetSheetOpen, content: AddPetScreen.init)
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
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                .fill(Color(.systemBackground))
                .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 2)
        }
    }
    
    var infoSheet: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    attributeCard(title: "Age", value: "\(pet.age)")
                    attributeCard(title: "Gender", value: "\(pet.gender.rawValue.capitalized)")
                    attributeCard(title: "Colour", value: "\(pet.colour)")
                    attributeCard(title: "Weight", value: "\(pet.weight) \(pet.weightUnit)")
                }
                Divider()
                    .background(.attributesText)
                    .padding()
                
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(pet.reminders) { reminder in
                            ReminderRow(petNotification: reminder)
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.top, 48)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerSize: CGSize(width: 36, height: 36))
                    .fill(Color(.detailSheet))
            }
        }
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
        pet:
                .init(
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
                    reminders: [.init(
                        id: "", title: "Feed",
                        body: "Test reminder",
                        date: Date(),
                        repeatInterval: .daily,
                        notificationType: .medication,
                        aditionalNotifications: false
                    ),
                                .init(
                                    id: "", title: "Feed",
                                    body: "Test reminder",
                                    date: Date(),
                                    repeatInterval: .daily,
                                    notificationType: .medication,
                                    aditionalNotifications: false
                                ),
                                .init(
                                    id: "", title: "Feed",
                                    body: "Test reminder",
                                    date: Date(),
                                    repeatInterval: .daily,
                                    notificationType: .medication,
                                    aditionalNotifications: false
                                )]
                )
    )
}
