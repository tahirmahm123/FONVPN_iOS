//
//  SettingsScreen.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI

struct SettingsScreen: View {
    @State private var detailsShown = false
    var body: some View {
        List{
            NavigationLink(destination: ConnectionSettingsScreen()
            ) {
                VStack(alignment: .leading) {
                    Text("Connection Settings")
                        .foregroundColor(Color(UIColor.label))
                    Text("Auto connect and security")
                        .font(.subheadline)
                        .foregroundColor(Color("FadedColor"))
                    
                }
            }
            NavigationLink(destination: AccountSettingsScreen()) {
                VStack(alignment: .leading) {
                    Text("My Account")
                        .foregroundColor(Color(UIColor.label))
                    Text("Subscription, devices, logout, etc.")
                        .font(.subheadline)
                        .foregroundColor(Color("FadedColor"))
                    
                }
            }
            NavigationLink(destination: SupportCenterView()
            ) {
                VStack(alignment: .leading) {
                    Text("Support Center")
                        .foregroundColor(Color(UIColor.label))
                    Text("Troubleshooting, reinstall vpn profile etc.")
                        .font(.subheadline)
                        .foregroundColor(Color("FadedColor"))
                    
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitle("Settings", displayMode: .large)
        .sheet(isPresented: $detailsShown) {
            NotificationDetailsScreen(onDismiss: {
                detailsShown.toggle()
            })
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsScreen()
        }
    }
}
