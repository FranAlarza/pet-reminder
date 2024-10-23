//
//  AddAnimalScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 10/10/24.
//

import SwiftUI
import FirebaseCore

enum AddPetScreenState {
    case error
    case success
    case loading
}

enum WeightUnit: String, CaseIterable {
    case lbs
    case kg
}

enum AddReminderSheetState {
    case add
    case edit
}

enum AddAnimalState {
    case add
    case edit
}

struct AddAnimalScreen: View {
    let mode: AddAnimalState
    private let hapticManager = HapticFeedbackManager.shared
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AnimalViewModel
    @State var state: AddPetScreenState?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // Form Data
    @State var animal = Animal()
    @State var inputImage: UIImage?

    // Notifications
    @State var animalNotification: Notification = .init()
    
    // Sheets Controls
    @State var isTakePhotoSheetShowed: Bool = false
    @State var isShowingImagePicker: Bool = false
    @State var isShowingAddReminder: Bool = false
    @State var isSubscriptionPresented: Bool = false
    @State var addReminderSheetState: AddReminderSheetState = .add
    
    let action: ((Animal) -> Void)?

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
                        state = .loading
                        switch mode {
                            case .add:
                            do {
                                try await viewModel.addAnimalWithReminders(animal: animal)
                                hapticManager.playHapticFeedback(type: .success)
                                AnalitycsManager.shared.log(.animalCreated(AnimalAnalitycsEvent(animal: animal)))
                                dismiss.callAsFunction()
                            } catch {
                                hapticManager.playHapticFeedback(type: .error)
                                state = .error
                            }
                        case .edit:
                            do {
                                try await viewModel.editAnimalWithReminders(animal: animal)
                                dismiss.callAsFunction()
                                action?(animal)
                            } catch {
                                hapticManager.playHapticFeedback(type: .success)
                                state = .error
                            }
                        }
                    }
                }) {
                    Text(mode == .add ? "Add Pet" : "Update Pet")
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
        .onChange(of: inputImage, perform: { newImage in
            if let newImage {
                animal.image = newImage.convertImageToBase64String() ?? ""
                hapticManager.playHapticFeedback(type: .success)
            }
        })
        .animation(.easeInOut, value: animal.notifications)
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
                .presentationDetents([.fraction(0.6)])
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
                TextField("Name", text: $animal.name)
                    .submitLabel(.next)
                TextField("Breed", text: $animal.breed)
                    .submitLabel(.next)
                TextField("Color", text: $animal.colour)
                    .submitLabel(.next)
                HStack {
                    TextField("Weight", value: $animal.weight, format: .number)
                        .keyboardType(.numberPad)
                        .submitLabel(.next)
                    Picker("Unit", selection: $animal.weightUnit) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(LocalizedStringResource(stringLiteral: unit.rawValue)).tag(unit.rawValue)
                        }
                    }
                }
                DatePicker("Birthday", selection: $animal.birth, displayedComponents: [.date])
            }
            reminderSection
        }
    }
    
    var reminderSection: some View {
        Section("Reminders") {
            if !animal.notifications.isEmpty {
                ForEach(animal.notifications, id: \.id) { notification in
                    HStack(spacing: 24) {
                        Image(systemName: notification.notificationType.iconKey)
                        VStack(alignment: .leading, spacing: 12) {
                            Text(notification.title)
                                .font(.headline)
                            Text(notification.body)
                        }
                        Spacer()
                        
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                            .onTapGesture {
                                animal.notifications.removeAll(where: { $0.id == notification.id })
                                hapticManager.playHapticFeedback(type: .success)
                            }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        animalNotification = notification
                        addReminderSheetState = .edit
                        isShowingAddReminder.toggle()
                    }
                }
            }
            
            Button {
                addReminderSheetState = .add
                hapticManager.playHapticFeedback(type: .success)
                isShowingAddReminder.toggle()
            } label: {
                Image(systemName: "plus")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color(.attributesText))
            }

        }
    }
    
    var animalTypePicker: some View {
        Picker("Pet Type", selection: $animal.type) {
            ForEach(AnimalType.allCases, id: \.self) { type in
                Text(LocalizedStringResource(stringLiteral: type.rawValue)).tag(type)
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
        AddReminderFormView(petNotification: $animalNotification) {
            switch addReminderSheetState {
            case .add:
                animal.notifications.append(animalNotification)
            case .edit:
                animal.notifications.removeAll(where: { $0.id == animalNotification.id })
                animal.notifications.append(animalNotification)
            }
            animalNotification = Notification()
        }
    }
}

#Preview {
    AddAnimalScreen(mode: .add, action: nil)
}
