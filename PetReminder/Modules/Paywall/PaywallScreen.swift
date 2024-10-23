//
//  PaywallScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 23/10/24.
//

import SwiftUI

struct PaywallScreen: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var offeringRepository: OfferingRepository = OfferingRepository()
    @State var selectedSubscription: PackageViewModel = PackageViewModel()
    
    var body: some View {
        VStack {
            Image(.place)
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Subscribe for premium features")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text("No commitment cancel any time")
                    .font(.system(size: 16, design: .rounded))
            }
            .background()
            
            VStack(
                spacing: 16,
                content: {
                    ForEach(offeringRepository.packagesViewModels) { purchaseItem in
                        PaywallItemView(
                            package: purchaseItem,
                            isSelected: $selectedSubscription
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedSubscription = purchaseItem
                        }
                }
                Button("Get Subscription",
                       action: {
                    Task {
                        await offeringRepository.purchase(selectedSubscription)
                    }
                })
                .buttonStyle(BorderedButtonStyle())
                
                Button("Restore purchases",
                       action: {
                    Task {
                        await offeringRepository.restorePurchases()
                    }
                })
                .font(.footnote)
                .controlSize(.mini)
                
                Text(
                    "Terms and conditions apply. Subscriptions will be changed via your iTunes account. [Terms of Use](https://www.aibowling.app/terms-and-condictions) and [Privacy Policy](https://www.aibowling.app/privacy-policy)"
                )
                .font(.caption)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            })
            .padding()
            
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                dismiss.callAsFunction()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.attributesText)
                    .padding()
            })
        }
        .onChange(of: offeringRepository.purchaseCompleted) { newValue in
            if newValue {
                dismiss.callAsFunction()
            }
        }
    }
}

#Preview {
    PaywallScreen()
}

