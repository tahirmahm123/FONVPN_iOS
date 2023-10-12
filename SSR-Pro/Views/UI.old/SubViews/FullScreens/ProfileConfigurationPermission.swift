//
//  ProfileConfigurationPermission.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 06/07/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct ProfileConfigurationPermission: View {
    @EnvironmentObject var appConstants: AppConstants
    @State var installFailed = false
    var onDismiss: () -> Void
    var onSuccess: (() -> Void)?
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
            AnimationView(name: "VPNConfiguration",animationSpeed: 1,contentMode: .scaleAspectFit, play: .constant(true))
                .frame(maxWidth: UIScreen.main.bounds.size.width * 0.65, maxHeight: UIScreen.main.bounds.size.height * 0.45)
                .padding(5)
            Spacer()
            if installFailed {
                Text("VPN Configuration Failed. You must allow VPN Configuration in order to use VPN Lightning.")
                    .font(Font.custom("Urbanist", size: 18).weight(.semibold))
                    .foregroundColor(.red)
                    .padding()
                    .multilineTextAlignment(.center)
            } else {
                Text("You must allow for the VPN Lightning service to work.")
                    .font(Font.custom("Urbanist", size: 18).weight(.semibold))
                    .padding()
                    .multilineTextAlignment(.center)
            }
            Spacer()
            GradientButton(action: {
                Task {
                    let credentials = OpenVPN.Credentials(userDefaults.string(forKey: UserName) ?? "testing", userDefaults.string(forKey: Password) ?? "testing")
                    let cert =  ApiManager.shared.serversDetails?.openvpn?.certificate ?? ""
                    let selectedPortAndProtocol = appConstants.selectedPortAndProtocolOVPN
                    let remotes = "remote \(appConstants.selectedServer?.ip ?? "") \(selectedPortAndProtocol)"
                    let updatedCertWithRemotes = cert.replacingOccurrences(of: "[REMOTES]", with: remotes)
                    cfg = OpenVPN.AppConfiguration.makeUsingAttributes(
                        title: "\(appName) OpenVPN",
                        appGroup: appGroup,
                        configurationString: updatedCertWithRemotes, dnsServers: []
                    )
                    cfg?.username = credentials.username
                    do {
                        try await vpn.install(OVPNtunnelIdentifier, configuration: cfg!, extra: NetworkExtensionExtra())
                        onSuccess?() ?? onDismiss()
                    } catch {
                        $installFailed.wrappedValue = true
                    }
                }
            }) {
                Text("Allow VPN configuration")
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
struct ProfileConfigurationPermission_Previews: PreviewProvider {
    static var previews: some View {
        ProfileConfigurationPermission(onDismiss: {
            
        })
        .environmentObject(AppConstants.shared)
    }
}
