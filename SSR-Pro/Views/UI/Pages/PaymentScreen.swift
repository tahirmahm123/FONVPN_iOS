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
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var manager: PurchaseManager
    @Environment(\.colorScheme) var colorScheme
    @State private var showToast = true
    @State private var storeProducts: [Product] = []
    @State private var selectedProduct: Product?
    @State private var popularIdentifier: String?
    @State private var url = AcceptTermsURL
    @State private var showSafariView = false
    let redirectToRootNotification = NotificationCenter.default
        .publisher(for: .RedirectToRoot)
    var selectedProductdentifier: String {
        return selectedProduct?.id ?? ""
    }
    var topInset: CGFloat {
        if let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive })?.windows
            .first(where: { $0.isKeyWindow }) {
            return keyWindow.safeAreaInsets.top
        } else {
            return 0.0
        }
    }
    var body: some View {
        VStack{
            NavigationView{
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack{
                                    Image("SecurityIcon")
                                    Text("Anonymity and Identity Protection")
                                        .font(Font.system(size: 16))
                                    Spacer()
                                }
                                HStack{
                                    Image("ServersIcon")
                                    Text("Global Server Network")
                                        .font(Font.system(size: 16))
                                    Spacer()
                                }
                                HStack{
                                    Image("DevicesIcon")
                                    Text("Multiple Device Support")
                                        .font(Font.system(size: 16))
                                    Spacer()
                                }
                            }
                            .padding(.top, 6)
                            VStack {
                                if storeProducts.count > 0 || !showToast {
                                    ForEach(storeProducts , id: \.id) { product in
                                        Button(action: {
                                            selectedProduct = product
                                        }) {
                                            PaymentCell(product: product, selected: product.id == selectedProduct?.id, popular: product.id == popularIdentifier)
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
                            }.task {
                                $showToast.wrappedValue = true
                                Task {
                                    do {
                                        try await manager.loadProducts()
                                        let products = manager.products
                                        $storeProducts.wrappedValue = products
                                        if products.count > 0 {
                                            $selectedProduct.wrappedValue = products.first
                                            $popularIdentifier.wrappedValue = manager.popular
                                        }
                                        $showToast.wrappedValue = false
                                        print("All Products Fetched")
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                            if selectedProduct != nil && !showToast{
                                GradientButton(action: {
                                    $showToast.wrappedValue = true
                                    Task {
                                        do {
                                            try await manager.purchase(selectedProduct!)
                                            $showToast.wrappedValue = false
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }) {
                                    Text("Complete Purchase")
                                        .font(Font.custom("Urbanist", size: 16).weight(.semibold))
                                }
                                .padding(.bottom)
                            }
                            Text(verbatim: """
                                 Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.
                                 """)
                                .foregroundColor(Color(UIColor.lightText))
                                .font(.system(size: 14))
                            HStack {
                                Button(action: {
                                    url = PrivacyPolicyURL
                                    showSafariView.toggle()
                                }) {
                                    Text("Privacy Policy")
                                        .font(Font.system(size: 14))
                                }
                                Spacer()
                                Button(action: {
                                    url = AcceptTermsURL
                                    showSafariView.toggle()
                                }) {
                                    Text("Terms of Service")
                                        .font(Font.system(size: 14))
                                }
                                Spacer()
                                Button(action: {
                                    Task {
                                        do {
                                            try await AppStore.sync()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }) {
                                    Text("Restore Purchase")
                                        .font(Font.system(size: 14))
                                }
                            }
                            .padding(.top)
                        }
                        .frame(minHeight: geometry.size.height - topInset)
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
                .fullScreenCover(isPresented: $showSafariView) {
                    SafariView(url: URL(string: url)!).edgesIgnoringSafeArea(.all)
                }
                .background(ZStack {
                    LinearGradient(colors: [Color("BackgroundGradientColor1"), Color("BackgroundGradientColor2")], startPoint: .leading, endPoint: .trailing)
                    Image("Background")
                })
                .foregroundColor(.white)
            }
        }
        .onReceive(redirectToRootNotification) { (notification: Notification) in
            router.setRoot(views: [SplashController.vc()])
        }
        .onAppear {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .clear
//            self.parent.navigationBar.standardAppearance = appearance;
//            self.parent.navigationBar.scrollEdgeAppearance = self.parent.navigationBar.standardAppearance
        }
    }
}
//struct PaymentScreenOld: View {
//    var onDismiss: () -> Void
//    @EnvironmentObject var appConstants: AppConstants
//    @Environment(\.colorScheme) var colorScheme
//    @State private var showToast = true
//    @State private var storeProducts: [SKProduct] = []
//    @State private var selectedProduct: SKProduct?
//    @State private var popularIdentifier: String?
//    var selectedProductdentifier: String {
//        return selectedProduct?.productIdentifier ?? ""
//    }
//    var body: some View {
//        VStack{
//            NavigationView{
//                GeometryReader { geometry in
//                    ScrollView {
//                        VStack {
//                            VStack(alignment: .leading, spacing: 20) {
//                                HStack{
//                                    Image("SecurityIcon")
//                                    Text("Anonymity and Identity Protection")
//                                        .font(Font.system(size: 16))
//                                    Spacer()
//                                }
//                                HStack{
//                                    Image("ServersIcon")
//                                    Text("Global Server Network")
//                                        .font(Font.system(size: 16))
//                                    Spacer()
//                                }
//                                HStack{
//                                    Image("DevicesIcon")
//                                    Text("Multiple Device Support")
//                                        .font(Font.system(size: 16))
//                                    Spacer()
//                                }
//                            }
//                            .padding(.top, 6)
//                            .foregroundColor(.white)
//                            VStack {
//                                if storeProducts.count > 0 {
//                                    ForEach(storeProducts , id: \.productIdentifier) { product in
//                                        Button(action: {
//                                            $selectedProduct.wrappedValue = product
//                                        }) {
//                                            PaymentCell(product: product, selected: product.productIdentifier == selectedProduct?.productIdentifier, popular: product.productIdentifier == popularIdentifier)
//                                        }
//                                        
//                                    }
//                                } else {
//                                    Spacer()
//                                    HStack {
//                                        Spacer()
//                                    }
//                                }
//                            }
//                            .padding(.vertical)
//                            .foregroundColor(.white)
//                            .toast(isPresenting: $showToast) {
//                                AlertToast(displayMode: .alert, type: .loading, title: "Please wait")
//                            }
//                            GradientButton(action: {
//                                StoreObserver.shared.buy(selectedProduct!)
//                            }) {
//                                Text("Complete Purchase")
//                                    .font(Font.custom("Urbanist", size: 16).weight(.semibold))
//                            }
//                            .disabled(selectedProduct == nil)
//                            .padding(.bottom)
//                            Text(verbatim: "Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period. Your account will be charged for renewal within 24 hours prior to the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.")
//                                .foregroundColor(.white)
//                                .font(Font.custom("Urbanist", size: 14))
//                            HStack {
//                                Button(action: {
//                                    
//                                }) {
//                                    Text("Privacy Policy")
//                                        .font(Font.system(size: 14))
//                                }
//                                Spacer()
//                                Button(action: {
//                                    
//                                }) {
//                                    Text("Terms of Service")
//                                        .font(Font.system(size: 14))
//                                }
//                                Spacer()
//                                Button(action: {
//                                    
//                                }) {
//                                    Text("Restore Purchase")
//                                        .font(Font.system(size: 14))
//                                }
//                            }
//                            .padding(.top)
//                        }
//                        .frame(minHeight: geometry.size.height)
//                               //- (UIApplication.shared.windows.first?.safeAreaInsets.top  ?? 0.0))
//                        .padding(.horizontal)
//                    }
//                }
//                .accentColor(Color("AccentColor"))
//                .navigationBarItems(trailing: Button(action: onDismiss) {
//                    Image(systemName: "xmark")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                        .foregroundColor(.accentColor)
////                        .padding()
//                })
//                .navigationBarItems(leading: Text("Choose Your Plan")
//                    .foregroundColor(.white)
//                    .font(Font.custom("Urbanist", size: 22).weight(.bold))
//                    .multilineTextAlignment(.center))
//                .onAppear(perform: {
//                    
//                    appConstants.plans(completion: { (products: [SKProduct], popular: String) in
//                        showToast.toggle()
//                        $storeProducts.wrappedValue = products
//                        if products.count > 0 {
//                            $selectedProduct.wrappedValue = products.first
//                            $popularIdentifier.wrappedValue = popular
//                        }
//                        print("All Products Fetched")
//                    })
//                })
//                .background(ZStack {
//                    LinearGradient(colors: [Color("BackgroundGradientColor1"), Color("BackgroundGradientColor2")], startPoint: .leading, endPoint: .trailing)
//                    Image("Background")
//                })
//            }
//        }
//    }
//}

struct PaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScreen(onDismiss: {
            
        })
        .environmentObject(AppConstants.shared)
    }
}
