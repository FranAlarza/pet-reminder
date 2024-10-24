//
//  SettingsScreen.swift
//  PetReminder
//
//  Created by Fran Alarza on 8/10/24.
//

import SwiftUI
import StoreKit
import Shake
import RevenueCatUI

struct SettingsScreen: View {
    @Environment(\.requestReview) var requestReview
    @ObservedObject var viewModel: SettingsViewModel = SettingsViewModel()
    @State var isSubscriptionSheetPresented: Bool = false
    var body: some View {
        VStack(alignment: .center) {
            List {
                suscribeButton
                
                Section("INFO") {
                    Button {
                        AnalitycsManager.shared.log(.rateUs)
                        requestReview.callAsFunction()
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "star.fill")
                            Text("Rate Us")
                                .foregroundStyle(.detailSheet)
                                .font(.body)
                                .bold()
                            Spacer()
                            
                        }
                    }
                    
                    Button {
                        AnalitycsManager.shared.log(.shakeOpen)
                        Shake.show()
                    } label: {
                        HStack(spacing: 20) {
                            Image(systemName: "lightbulb.fill")
                            Text("Request New Feature")
                                .foregroundStyle(.detailSheet)
                                .font(.body)
                                .bold()
                            Spacer()
                        }
                    }
                }
                .listRowBackground(Color.gray.opacity(0.1))
                
                HStack(spacing: 4) {
                    Text("Made with")
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                    
                    Text("by")
                    
                    Link("Fran Alarza", destination: URL(string: "https://www.linkedin.com/in/francisco-javier-alarza-sanchez/")!)
                        .foregroundColor(.blue)
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.body)
            }

        }
        .fullScreenCover(isPresented: $isSubscriptionSheetPresented, content: {
            PaywallView()
        })
        .scrollContentBackground(.hidden)
    }
    
    var suscribeButton: some View {
        return Button {
            isSubscriptionSheetPresented.toggle()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
                Text(LocalizedStringResource(stringLiteral: viewModel.subscriptionState.title))
                    .foregroundStyle(.white)
                    .font(.body)
                    .bold()
                Spacer()
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.attributesText)
                    .shadow(color: Color.gray.opacity(0.4), radius: 8, x: 0, y: 2)
            }
        }
    }
}

#Preview {
    SettingsScreen(viewModel: SettingsViewModel())
}
