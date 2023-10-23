//
//  NotificationDetailsScreen.swift
//  VIS VPN
//
//  Created by Azhar's Macbook Pro on 25/06/2023.
//

import SwiftUI

struct NotificationDetailsScreen: View {
    var onDismiss: (() -> Void)?
    var body: some View {
        NavigationView{
            VStack {
                Text("Your VPN subscription is expiring soon. Don't miss out on uninterrupted protection and privacy. Renew your subscription now to continue enjoying all the benefits of our VPN service. Stay secure and browse with confidence.")
                    .padding()
                Spacer()
            }
            .navigationBarTitle("Important Notice", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                onDismiss?()
            }) {
                Image(systemName: "xmark")
            })
        }
    }
}

struct NotificationDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationDetailsScreen()
    }
}
