//
//  AddPetScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 10/10/24.
//

import SwiftUI
import FirebaseCore

enum AddPetScreeState {
    case error
    case success
    case loading
}

enum WeightUnit: String, CaseIterable {
    case lbs
    case kg
}

struct AddPetScreen: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: PetViewModel
    @State var state: AddPetScreeState?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // Form Data
    @State var inputImage: UIImage?
    @State var name: String = "Daisy"
    @State var breed: String = "Podenco"
    @State var type: AnimalType = .dog
    @State var color: String = "Canela"
    @State var weight: Double = 5
    @State var weightUnit: WeightUnit = .kg
    @State var birth: Date = Date()
    @State var petNotification: PetNotification = .init(title: "", body: "", date: Date(), repeatInterval: .noRepeat, notificationType: .other, aditionalNotifications: false)
    @State var petNotifications: [PetNotificationDTO] = []
    
    // Sheets Controls
    @State var isTakePhotoSheetShowed: Bool = false
    @State var isShowingImagePicker: Bool = false
    @State var isShowingAddReminder: Bool = false
    
    func addReminder() async {
        await viewModel.addNotification(pet: petNotification)
        let noti = Mappers.mapPetDTO(petNotification)
        petNotifications.append(noti)
        petNotification = .init(title: "", body: "", date: Date(), repeatInterval: .noRepeat, notificationType: .other, aditionalNotifications: false)
    }

    var body: some View {
        VStack {
            HStack {
                dismissButton
                Spacer()
            }
            .padding()
            
            petPhoto
            .padding()
            .onTapGesture {
                isTakePhotoSheetShowed = true
            }
            
            petInfoForm
            
            Button(
                action: {
                    UIApplication.shared.dismissKeyboard()
                    Task {
                        await addPetAction()
                    }
                }) {
                Text("Add Pet")
                    .padding()
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.attributesText))
                    .foregroundStyle(.white)

            }
            .cornerRadius(16)
            .padding(.horizontal)
            Spacer()
        }
        .animation(.easeInOut, value: petNotifications)
        .overlay(content: {
            if state == .loading {
                LoadingView()
            }
        })
        .sheet(isPresented: $isTakePhotoSheetShowed) {
            takePhotoSheetOptions
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(
                sourceType: sourceType,
                selectedImage: $inputImage
            )
        }
        .sheet(isPresented: $isShowingAddReminder) {
            addRemainderForm
        }
    }
    
    var dismissButton: some View {
        Button(action: dismiss.callAsFunction,
               label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 26))
                .foregroundStyle(Color(.attributesText))
        })
    }
    
    var petPhoto: some View {
        VStack(alignment: .center) {
            if let inputImage {
                Image(uiImage: inputImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } else {
                    ZStack {
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 4))
                            .fill(Color.gray)
                            .frame(width: 150, height: 150)
                        Image(systemName: "dog.fill")
                    }
                    
                }
        }
    }
    
    var petInfoForm: some View {
        Form {
            Section("Pet Information") {
                animalTypePicker
                TextField("Name", text: $name)
                    .submitLabel(.next)
                TextField("Breed", text: $breed)
                    .submitLabel(.next)
                TextField("Color", text: $color)
                    .submitLabel(.next)
                HStack {
                    TextField("Weight", value: $weight, format: .number)
                        .keyboardType(.numberPad)
                        .submitLabel(.next)
                    Picker("Unit", selection: $weightUnit) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue.capitalized)
                        }
                    }
                }
                DatePicker("Birthday", selection: $birth, displayedComponents: [.date])
            }
            reminderSection
        }
    }
    
    var reminderSection: some View {
        Section("Reminders") {
            if !petNotifications.isEmpty {
                ForEach(petNotifications, id: \.id) { notification in
                    HStack(spacing: 16) {
                        Image(systemName: "cross.circle.fill")
                        VStack(alignment: .leading, spacing: 12) {
                            Text(notification.title)
                                .font(.headline)
                            Text(notification.body)
                        }
                        Spacer()
                        Button {
                            petNotifications.removeAll(where: { $0.id == notification.id })
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            
            Button {
                isShowingAddReminder.toggle()
            } label: {
                Image(systemName: "plus")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color(.attributesText))
            }

        }
    }
    
    var animalTypePicker: some View {
        Picker("Pet Type", selection: $type) {
            ForEach(AnimalType.allCases, id: \.self) { type in
                Text(type.rawValue.capitalized)
            }
        }
    }
    
    var takePhotoSheetOptions: some View {
        VStack(alignment: .leading, spacing: 32) {
            Button {
                self.sourceType = .camera
                self.isTakePhotoSheetShowed = false
                self.isShowingImagePicker = true
            } label: {
                HStack {
                    Image(systemName: "camera")
                    Text("Take Photo")
                }
            }
            
            Button {
                self.sourceType = .photoLibrary
                self.isTakePhotoSheetShowed = false
                self.isShowingImagePicker = true
            } label: {
                HStack {
                    Image(systemName: "photo")
                    Text("Open Gallery")
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(32)
        .font(.headline)
        .presentationDetents([.fraction(0.25)])
        .onTapGesture {
            UIApplication.shared.dismissKeyboard()
        }
    }
    
    var addRemainderForm: some View {
        AddReminderFormView(petNotification: $petNotification) {
            await addReminder()
        }
        .presentationDetents([.fraction(0.6)])
    }
    
    func addPetAction() async {
        state = .loading
        do {
            try await viewModel.addPet(
                pet: .init(
                    image: "",
                    name: name,
                    breed: breed,
                    type: type.rawValue,
                    colour: color,
                    birth: Timestamp(date: birth),
                    weight: weight,
                    weightUnit: weightUnit.rawValue,
                    gender: .male
                ),
                reminders: petNotifications,
                inputImage: inputImage ?? UIImage()
            )
            print("Pet added successfully")
            dismiss.callAsFunction()
        } catch {
            state = .error
            print("Error adding pet: \(error)")
        }
    }
}

#Preview {
    AddPetScreen()
}
