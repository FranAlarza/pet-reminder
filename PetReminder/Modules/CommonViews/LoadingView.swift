//
//  LoadingView.swift
//  PetReminder
//
//  Created by Fran Alarza on 13/10/24.
//

import Foundation
import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
        ZStack {
            LottieView(
                animation: .named("LoadingAnimation")
            )
            .playing(loopMode: .loop)
            .aspectRatio(1.5, contentMode: .fit)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.attributesText).opacity(0.5))
    }
}

#Preview {
    LoadingView()
}
