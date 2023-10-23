//
//  ProductManager.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 31/08/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import StoreKit
@MainActor
class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    @Published
    private(set) var products: [Product] = []
    @Published
    private(set) var popular: String = ""
    private var productsLoaded = false
    
    private var updates: Task<Void, Never>? = nil
    
    init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
        (products, popular) = await AppConstants.shared.plans()
        self.products = try await Product.products(for: ApiManager.shared.plansIdentifier!)
        self.productsLoaded = true
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase(options: Set([
            Product.PurchaseOption.appAccountToken(UUID(uuidString: userDefaults.string(forKey: userUUID) ?? UUID().uuidString)!)
        ]))
        
        switch result {
            case let .success(.verified(transaction)):
                    // Successful purhcase
                print("Success Transaction \(transaction)")
                await transaction.finish()
//                NotificationCenter.default.post(name: .RedirectToRoot, object: nil)
            case let .success(.unverified(_, error)):
                    // Successful purchase but transaction/receipt can't be verified
                    // Could be a jailbroken phone
                print(error)
                break
            case .pending:
                    // Transaction waiting on SCA (Strong Customer Authentication) or
                    // approval from Ask to Buy
                break
            case .userCancelled:
                    // ^^^
                break
            @unknown default:
                break
        }
    }
    
    @Published
    private(set) var purchasedProductIDs = Set<String>()
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                    // Using verificationResult directly would be better
                    // but this way works for this tutorial
                print(verificationResult)
                await self.updatePurchasedProducts()
            }
        }
    }
}
