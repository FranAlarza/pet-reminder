//
//  AddPetScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 10/10/24.
//

import SwiftUI
import FirebaseCore

/*
 var id: String
 let image: String
 let name: String
 let breed: String
 let type: String
 let colour: String
 let birth: Timestamp
 **/

struct AddPetScreen: View {
    @Environment(\.dismiss) var dismiss
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // Form Data
    @State var inputImage: UIImage?
    @State var name: String = "Daisy"
    @State var breed: String = "Podenco"
    @State var type: AnimalType = .dog
    @State var color: String = "Canela"
    @State var birth: Date = Date()
    
    // Sheets Controls
    @State var isTakePhotoSheetShowed: Bool = false
    @State var isShowingImagePicker: Bool = false
    @State var isShowingAddReminder: Bool = false
    
    func addPet() async {
        do {
            let url = try await FirestoreService.uploadImage(inputImage) ?? ""
            let dto: PetDTO = .init(
                image: url,
                name: name,
                breed: breed,
                type: type.rawValue,
                colour: color,
                birth: Timestamp(date: birth)
            )
            try await FirestoreService.request(PetsEndpoints.postPet(dto: dto))
            print("Pet added successfully")
            dismiss.callAsFunction()
        } catch {
            print("Error adding pet: \(error)")
        }
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
            
            Button(action: {
                UIApplication.shared.dismissKeyboard()
                Task {
                    await addPet()
                }
            }) {
                Text("Add Pet")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .buttonStyle(.borderedProminent)
            Spacer()
        }
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
                .foregroundStyle(Color(.primary))
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
                DatePicker("Birthday", selection: $birth, displayedComponents: [.date])
            }
            
            Section("Reminders") {
                Button {
                    isShowingAddReminder.toggle()
                } label: {
                    Image(systemName: "plus")
                        .frame(maxWidth: .infinity, alignment: .center)
                }

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
    }
    
    var addRemainderForm: some View {
        Form {
            Text("Sheet para añadir un recordatorio")
        }
        .presentationDetents([.fraction(0.3)])
    }
}

#Preview {
    AddPetScreen()
}
