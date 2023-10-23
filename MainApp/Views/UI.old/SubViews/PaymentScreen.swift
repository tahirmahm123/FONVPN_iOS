//
//  PaymentScreen.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 12/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import StoreKit

struct PaymentScreen: View {
    var onDismiss: () -> Void
    @EnvironmentObject var appConstants: AppConstants
    @Environment(\.colorScheme) var colorScheme
    @State private var showToast = true
    @State private var storeProducts: [SKProduct] = []
    @State private var selectedProduct: SKProduct?
    @State private var popularIdentifier: String?
    var selectedProductdentifier: String {
        return selectedProduct?.productIdentifier ?? ""
    }
    var body: some View {
        VStack{
//            HStack {
//                
//                Spacer()
//
//            }
//            .padding(.bottom, 2)
//            .padding(.horizontal)
//            .background(Color(UIColor.systemBackground).opacity(0.3))
            NavigationView{
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack{
                                    Image("TimerIcon")
                                    Text("Unlimited & fast connection")
                                        .font(Font.custom("Urbanist", size: 16))
                                    Spacer()
                                }
                                HStack{
                                    Image("ShieldIcon")
                                    Text("Secure streaming and browsing")
                                        .font(Font.custom("Urbanist", size: 16))
                                    Spacer()
                                }
                                HStack{
                                    Image("247Icon")
                                    Text("24/7 Customer support")
                                        .font(Font.custom("Urbanist", size: 16))
                                    Spacer()
                                }
                            }
                            .padding(.top, 6)
                            VStack {
                                if storeProducts.count > 0 {
                                    ForEach(storeProducts , id: \.productIdentifier) { product in
                                        Button(action: {
                                            $selectedProduct.wrappedValue = product
                                        }) {
                                            PaymentCell(product: product, selected: product.productIdentifier == selectedProduct?.productIdentifier, popular: product.productIdentifier == popularIdentifier)
                                        }
                                        
                                    }
                                } else {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.vertical)
                            .toast(isPresenting: $showToast) {
                                AlertToast(displayMode: .alert, type: .loading, title: "Please wait")
                            }
                            GradientButton(action: {
                                StoreObserver.shared.buy(selectedProduct!)
                            }) {
                                Text("Complete Purchase")
                                    .font(Font.custom("Urbanist", size: 16).weight(.semibold))
                            }
                            .disabled(selectedProduct == nil)
                            .padding(.bottom)
                            Text(verbatim: "Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.")
                                .foregroundColor(.secondary)
                                .font(Font.custom("Urbanist", size: 14))
                            HStack {
                                Button(action: {
                                    
                                }) {
                                    Text("Privacy Policy")
                                        .font(Font.system(size: 14))
                                }
                                Spacer()
                                Button(action: {
                                    
                                }) {
                                    Text("Terms of Service")
                                        .font(Font.system(size: 14))
                                }
                                Spacer()
                                Button(action: {
                                    
                                }) {
                                    Text("Restore Purchase")
                                        .font(Font.system(size: 14))
                                }
                            }
                            .padding(.top)
                        }
                        .frame(minHeight: geometry.size.height - (UIApplication.shared.windows.first?.safeAreaInsets.top  ?? 0.0))
                        .padding(.horizontal)
                    }
                }
                .accentColor(Color("AccentColor"))
                .navigationBarItems(trailing: Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.accentColor)
//                        .padding()
                })
                .navigationBarItems(leading: Text("Choose Your Plan")
                    .font(Font.custom("Urbanist", size: 22).weight(.bold))
                    .multilineTextAlignment(.center))
                .onAppear(perform: {
                    appConstants.plans(completion: { (products: [SKProduct], popular: String) in
                        showToast.toggle()
                        $storeProducts.wrappedValue = products
                        if products.count > 0 {
                            $selectedProduct.wrappedValue = products.first
                            $popularIdentifier.wrappedValue = popular
                        }
                        print("All Products Fetched")
                    })
                })
            }
        }
    }
}

struct PaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScreen(onDismiss: {
            
        })
        .environmentObject(AppConstants.shared)
    }
}
