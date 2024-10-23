//
//  PaywallItemView.swift
//  PetReminder
//
//  Created by Fran Alarza on 23/10/24.
//

import SwiftUI

struct PaywallItemView: View {
    let package: PackageViewModel
    @Binding var isSelected: PackageViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(package.title ?? "")
                Text(package.price)
            }
            Spacer()
            Image(systemName: package.id == isSelected.id ? "checkmark.circle" : "circle")
                .foregroundStyle(package.id == isSelected.id ? .attributesText : .gray)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(package.id == isSelected.id ? .attributesText : .gray, lineWidth: 2)
        )
    }
}

#Preview {
    VStack {
        PaywallItemView(
            package: .init(
                package: .init(identifier: "", packageType: .annual, storeProduct: .init(sk1Product: .init()), offeringIdentifier: "")
            ),
            isSelected: .constant(.init())
        )
        PaywallItemView(
            package: .init(
                package: .init(identifier: "", packageType: .annual, storeProduct: .init(sk1Product: .init()), offeringIdentifier: "")
                          ),
            isSelected: .constant(.init())
        )
    }
}
