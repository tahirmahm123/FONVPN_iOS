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
    
    var product: Product
    var selected: Bool
    var popular: Bool
    var duration: String {
        let amount = product.subscription?.subscriptionPeriod.value ?? 1
        var calculatedDuration = ""
        switch product.subscription?.subscriptionPeriod.unit {
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
            return $0.identifier == product.id
        })
        return plan?.savePercent ?? 0
    }
    var currencyCode: String{
        return product.priceFormatStyle.currencyCode
    }
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                VStack(alignment: .leading) {
                    Text(product.displayName)
                        .font(Font.system(size: 18).weight(.bold))
                    Text(product.description)
                        .foregroundColor(.gray)
                        .font(Font.system(size: 14).weight(.light))
//                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
//                        .background(LinearGradient(gradient: Gradient(colors: colorScheme == .light ? appConstants.gradientColors : [appConstants.gradientColors[1]]), startPoint: .leading, endPoint: .trailing))
//                        .clipShape(Capsule())
                }
                Spacer()
                if savePercent > 0 {
                    VStack {
                        Text("Save")
                        Text("\(savePercent)%")
                     }
                    .foregroundColor(.black)
                    .font(Font.system(size: 12).weight(.semibold))
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    .background(savePercent > 0 ? Color.green : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            HStack(alignment: .top) {
                HStack(alignment: .top){
                    HStack(alignment: .top,spacing: 2) {
                        Text(product.priceFormatStyle.locale.currencySymbol ?? "")
                            .font(Font.system(size: 14).weight(.bold))
                        Text(formattedPrice())
                            .font(Font.system(size: 20).weight(.bold))
                    }
                    Text(currencyCode)
                        .font(Font.system(size: 18).weight(.semibold))
                }
                Text(duration)
                    .font(Font.system(size: 14).weight(.semibold))
                Spacer()
            }
        }
        .foregroundStyle(Color.white)
        .padding()
        .background(ZStack {
            Color("PaymentCellColor")
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
        .onAppear {
//            print(savePercent)
        }
    }
    func formattedPrice() -> String {
        let locale = product.priceFormatStyle.locale
        let formatter = NumberFormatter()
        formatter.locale = locale
        
        formatter.numberStyle = .decimal
        return formatter.string(from: product.price as NSNumber) ?? ""
    }
}

struct PaymentCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var text = ""
        EmptyView()
//        let mockProduct = MockProduct(mockPrice: 9.99,
//                                      mockLocale: Locale.current,
//                                      mockNumberOfUnits: 1,
//                                      mockSubscriptionPeriod: nil)
//        PaymentCell(product: mockProduct, selected: false, popular: false)
//        .environmentObject(AppConstants.shared)
    }
}


