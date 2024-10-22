//
//  OfferingRepository.swift
//  PetReminder
//
//  Created by Fran Alarza on 22/10/24.
//

import Foundation
import RevenueCat

@MainActor
final class OfferingRepository: ObservableObject {
    
    @Published private(set) var packagesViewModels: [PackageViewModel] = []
    
    func start() async {
        do {
            let offerings = try await Purchases.shared.offerings()
            let packages = offerings.current?.availablePackages ?? []
            packagesViewModels = packages.map { PackageViewModel(package: $0) }
            print("Packages fetched: \(packagesViewModels)")
        } catch {
            print("Unable to fetch packages: \(error.localizedDescription)")
        }
    }
    
    func purchase(_ model: PackageViewModel) async {
        do {
            let _ = try await Purchases.shared.purchase(package: model.package)
        } catch {
            print("Unable to purchase package: \(error.localizedDescription)")
        }
    }
    
}

struct PackageViewModel: Identifiable {
    
    let package: Package
    
    var id: String { package.id }
    
    var title: String? {
        guard let susbcriptionPeriod = package.storeProduct.subscriptionPeriod else { return nil }
        switch susbcriptionPeriod.unit {
        case .month:
            return "Monthly"
        case .year:
            return "Annual"
        default:
            return nil
        }
    }
    
    var price: String {
        package.storeProduct.localizedPriceString
    }
}
