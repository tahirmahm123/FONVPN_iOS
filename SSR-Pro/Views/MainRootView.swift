//
//  RootView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 23/06/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
struct MainRootView: View {
    let nav: UINavigationController
    let router = AppRouter()
    let appConstants = AppConstants.shared
    let productManager = PurchaseManager.shared
    let view: AnyView
    var body: some View {
        view
            .environmentObject(router)
            .environmentObject(appConstants)
            .environmentObject(productManager)
            .onAppear {
                router.nav = nav
            }
    }
}

struct MainRootView_Previews: PreviewProvider {
    static var previews: some View {
        MainRootView(nav: UINavigationController(), view: AnyView(EmptyView()))
    }
}
