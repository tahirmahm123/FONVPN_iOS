//
//  IAPManager.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 12/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class IAPManager: NSObject {
    static let shared = IAPManager()
    
    
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    var completion: (([SKProduct]) -> Void)?
        // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(completion: @escaping (([SKProduct])->Void)){
        productsRequest.cancel()
            // Put here your IAP Products ID's
        let productIdentifiers = NSSet(array: ApiManager.shared.plansIdentifier!)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
        self.completion = completion
    }
}

extension IAPManager: SKProductsRequestDelegate {
        // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if response.products.count > 0 {
            iapProducts = response.products
            iapProducts.sort(by: {
                $0.price.compare($1.price) == ComparisonResult.orderedAscending
            })
            for product in iapProducts {
                print("productIdentifier - ", product.productIdentifier)
            }
        }
        print(response)
        completion!(response.products)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error load products", error)
    }
}
