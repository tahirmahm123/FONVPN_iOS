//
//  PaymentCell.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 13/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import StoreKit

struct PaymentCell: View {
    @EnvironmentObject var appConstants: AppConstants
    @Environment(\.colorScheme) var colorScheme
    
    var product: SKProduct
    var selected: Bool
    var popular: Bool
    var duration: String {
        let amount = product.subscriptionPeriod?.numberOfUnits ?? 1
        var calculatedDuration = ""
        switch product.subscriptionPeriod?.unit {
            case .day:
                calculatedDuration = amount > 1 ? "every \(amount) days" : "Daily"
            case .week:
                calculatedDuration = amount > 1 ? "every \(amount) weeks" : "Weekly"
            case .month:
                calculatedDuration = amount > 1 ? "every \(amount) months" : "Monthly"
            case .year:
                calculatedDuration = amount > 1 ? "every \(amount) years" : "Yearly"
            case .none:
                calculatedDuration = ""
            case .some(_):
                calculatedDuration = ""
        }
        return calculatedDuration == "" ? "" : "Billed \(calculatedDuration)"
    }
    var savePercent: Int {
        let plan = ApiManager.shared.plansData?.first(where: {
            return $0.identifier == product.productIdentifier
        })
        return plan?.savePercent ?? 0
    }
    var currencyCode: String{
        if  #available(iOS 16, *) {
            return product.priceLocale.currency?.identifier ?? ""
        } else {
            return product.priceLocale.currencyCode ?? ""
        }
    }
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(product.localizedTitle)
                    .foregroundColor(Color(UIColor.label))
                    .font(Font.custom("Urbanist", size: 18).weight(.bold))
                if popular {
                    Text("Most Popular")
                        .foregroundColor(popular ? .white : .clear)
                        .font(Font.custom("Urbanist", size: 14).weight(.semibold))
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? appConstants.gradientColors : [appConstants.gradientColors[1]]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(Capsule())
                }
                Spacer()
                HStack(alignment: .top){
                    HStack(alignment: .top,spacing: 2) {
                        Text(product.priceLocale.currencySymbol ?? "")
                            .foregroundColor(Color(UIColor.label))
                            .font(Font.custom("Urbanist", size: 14).weight(.bold))
                        Text(product.price.stringValue)
                            .foregroundColor(Color(UIColor.label))
                            .font(Font.custom("Urbanist", size: 20).weight(.bold))
                    }
                    
                    Text(currencyCode)
                        .foregroundColor(.secondary)
                        .font(Font.custom("Urbanist", size: 18).weight(.semibold))
                    
                }
            }
            HStack(alignment: .top) {
                Text(duration)
                    .foregroundColor(.secondary)
                    .font(Font.custom("Urbanist", size: 14).weight(.semibold))
                Spacer()
                
                Text("Save \(savePercent)%")
                    .foregroundColor(savePercent > 0 ? .white : .clear)
                    .font(Font.custom("Urbanist", size: 14).weight(.semibold))
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(savePercent > 0 ? Color.green : Color.clear)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(ZStack {
            Color.gray.opacity(0.1)
            if selected {
                LinearGradient(gradient: Gradient(colors: colorScheme == .light ? appConstants.gradientColors : [appConstants.gradientColors[1]]), startPoint: .leading, endPoint: .trailing)
                    .mask(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 3)
                    )
                    .padding(1)
            }
        })
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct PaymentCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var text = ""
        
        let mockProduct = MockProduct(mockPrice: 9.99,
                                      mockLocale: Locale.current,
                                      mockNumberOfUnits: 1,
                                      mockSubscriptionPeriod: nil)
        PaymentCell(product: mockProduct, selected: false, popular: false)
        .environmentObject(AppConstants.shared)
    }
}

class MockProduct: SKProduct {
    private var mockPrice: NSDecimalNumber
    private var mockLocale: Locale
    private var mockNumberOfUnits: Int
    private var mockSubscriptionPeriod: SKProductSubscriptionPeriod?
    
    init(mockPrice: NSDecimalNumber,
         mockLocale: Locale,
         mockNumberOfUnits: Int,
         mockSubscriptionPeriod: SKProductSubscriptionPeriod? = nil) {
        self.mockPrice = mockPrice
        self.mockLocale = mockLocale
        self.mockNumberOfUnits = mockNumberOfUnits
        self.mockSubscriptionPeriod = mockSubscriptionPeriod
        super.init()
    }
    
    override var price: NSDecimalNumber {
        return mockPrice
    }
    
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = mockLocale
        return formatter.string(from: mockPrice) ?? ""
    }
    
    override var priceLocale: Locale {
        return mockLocale
    }
    
    override var subscriptionPeriod: SKProductSubscriptionPeriod? {
        return mockSubscriptionPeriod
    }
    
        // Additional properties and methods if needed
    
        // ...
}

