//
//  NotificationPermission.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 06/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct NotificationPermission: View {
    var onDismiss: () -> Void
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.accentColor)
                        .padding()
                }
            }
            Text("Get Security and Privacy alerts")
                .font(Font.custom("Urbanist", size: 30).weight(.bold))
                .multilineTextAlignment(.center)
            Spacer()
            AnimationView(name: "Notification",animationSpeed: 1,contentMode: .scaleAspectFit, play: .constant(true))
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.65, maxHeight: UIScreen.main.bounds.size.height * 0.45)
                .padding(5)
            Spacer()
            Text("We only send notifications regarding billing, offers and service-related topic.")
                .font(Font.custom("Urbanist", size: 18))
                .padding()
                .multilineTextAlignment(.center)
            Spacer()
            GradientButton(action: {
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                    if granted {
                        print("Notification authorization granted")
                    } else {
                        print("Notification authorization denied")
                    }
                    onDismiss()
                }
            }) {
                Text("Allow Notifications")
            }
            .padding(.horizontal)
            Button(action: {
                onDismiss()
            }) {
                Text("Skip")
                    .padding()
            }
            .padding(.horizontal)
        }
        .accentColor(Color("AccentColor"))
    }
}

struct NotificationPermission_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPermission(onDismiss: {
            
        })
            .environmentObject(AppConstants.shared)
    }
}
