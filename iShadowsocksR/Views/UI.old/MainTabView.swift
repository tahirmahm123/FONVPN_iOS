//
//  MainTabView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 31/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
//    @EnvironmentObject var api: ApiManager
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image("HomeTab\(selectedTab == 0 ? "Active" : "")")
                    Text("Connect")
                }
                .tag(0)
            
            LocationsView(tabSelection: $selectedTab)
                .tabItem {
                    Image("LocationTab\(selectedTab == 1 ? "Active" : "")")
                    Text("Location")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image("SettingsTab\(selectedTab == 2 ? "Active" : "")")
                    Text("Settings")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image("AccountTab\(selectedTab == 3 ? "Active" : "")")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(Color("ThemeColor"))
        .background(Color(UIColor.systemGray6))
        .onAppear(perform: {
//            api.updateServersList(completion: { completed in
//                print("Fetching Servers")
//            })
                // correct the transparency bug for Tab bars
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            

        })
    }
    
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppConstants())
//            .environmentObject(ApiManager.shared)
    }
}
