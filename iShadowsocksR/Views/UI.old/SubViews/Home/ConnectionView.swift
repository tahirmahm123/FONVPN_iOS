//
//  ConnectionView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 31/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import Lottie
import NetworkExtension

struct ConnectionView: View {
    @EnvironmentObject var appConstants: AppConstants
    @Environment(\.colorScheme) var colorScheme
    @Binding var connectVPN: Bool
    @Binding var allowConfigurationToggle: Bool
    @State var connectionStatus: NEVPNStatus = .disconnected
    @State var isConnected = false
    @State var quickConnect = false
//    let vpnStatusChangeNotification = NotificationCenter.default
//        .publisher(for: VPNNotification.didChangeStatus)
//    let nevpnStatusChangeNotification = NotificationCenter.default
//        .publisher(for: NSNotification.Name.NEVPNStatusDidChange)
//    let vpnFailedNotification = NotificationCenter.default
//        .publisher(for: VPNNotification.didFail)
//    let connectVPNNotification = NotificationCenter.default
//        .publisher(for: .ServerSelected)
    
    var body: some View {
        VStack(alignment: .center) {
            if connectionStatus == .connected {
                ConnectedServerView(connectionState: connectionStatus)
            }
            VStack {
                HStack {
                    switch connectionStatus {
                        case .connected:
                            Image("ConnectedStateIcon")
                            Text("Connected! You are secured now.")
                                .foregroundColor(.green)
                        case .connecting:
                            Image("ProcessingStateIcon")
                            Text("Connecting...")
                                .foregroundColor(Color("ConnectingStateTextColor"))
                                .frame(width: .infinity)
                        case .disconnected:
                            Image("DisconnectedStateIcon")
                            Text("Unprotected! Connect to stay safe.")
                                .foregroundColor(.red)
                        case .disconnecting:
                            Image("ProcessingStateIcon")
                            Text("Disconnecting...")
                                .foregroundColor(.yellow)
                    }
                }
                Button(action: {
                    print("Connecting")
                    appConstants.validateVPNConfiguration(action: {
                        connectVPN.toggle()
                        allowConfigurationToggle.toggle()
                    }, onSuccess: {
                        connectionHandling()
                    })
                }) {
                    VStack {
                        switch connectionStatus {
                            case .connected:
                                Text("Disconnect.")
                                    .foregroundColor(.white)
                            case .connecting, .disconnecting:
                                Text("        ")
                            case .disconnected:
                                Text("Quick Connect")
                                    .foregroundColor(.white)
                        }
                    }.padding(4)
                }
                .padding(.vertical, 8)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(backgroundColor())
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    //            .border(borderColor(), width: 2.0)
            }
            .padding(EdgeInsets(top: 16, leading: 15, bottom: 16, trailing: 15))
            .background(Color("ConnectionButtonContainerBG"))
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
        }
//        .onReceive(vpnStatusChangeNotification) { (notification: Notification) in
//            print("VPN Status Changed Notification")
//            
//            print("VPNStatusDidChange: \(notification.vpnStatus)")
//            connectionStatus = notification.vpnStatus
//            vpnStatus = notification.vpnStatus
//            if notification.vpnStatus == .connected {
//                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
//            }
//            NotificationCenter.default.post(name: .VPNTimer, object: self, userInfo: [
//                "Status": connectionStatus
//            ])
//        }
//        .onReceive(vpnFailedNotification) { (notification: Notification) in
//            print("VPNStatusDidFail: \(notification.vpnError.localizedDescription)")
//        }
//        .onReceive(connectVPNNotification) { (notification: Notification) in
//            switch(vpnStatus) {
//                case .disconnecting, .connecting, .connected:
//                    disconnect()
//                    connectionHandling()
//                case .disconnected:
//                    connectionHandling()
//            }
//        }
//        .onReceive(nevpnStatusChangeNotification) { (notification: Notification) in
//            NotificationCenter.default.post(name: VPNNotification.didChangeStatus, object: nil, userInfo: ["Status": neConnectStatus])
//        }
    }
    

    
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        @State var vpnConfigurationScreenShown = false
        @State var connectVPNClicked = false
        ConnectionView(connectVPN: $connectVPNClicked, allowConfigurationToggle: $vpnConfigurationScreenShown)
            .environmentObject(AppConstants())
    }
}
