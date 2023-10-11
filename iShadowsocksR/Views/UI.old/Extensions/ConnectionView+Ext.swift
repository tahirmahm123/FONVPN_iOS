//
//  ConnectionView+Ext.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 31/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI
import NetworkExtension

extension ConnectionView {
    func connectionHandling() {
            //        if !userDefaults.bool(forKey: isPaidUser){
            //            if userDefaults.bool(forKey: isFromUserName){
            //                self.showAlert(caller: self, title: "Expired", message: "Please renew your plan.")
            //            } else {
            //                let proVC = PremiumScreenVC.premiumScreenVC()
            //                proVC.modalPresentationStyle = .fullScreen
            //                self.presentDetail(proVC)
            //            }
            //            return
            //        }
        if connectionStatus == .connected{
            self.isConnected = true
        } else {
            self.isConnected = false
        }
        switch connectionStatus {
            case .connected:
                self.disconnect()
            case .disconnected:
//                self.connectIKEv2()
                if appConstants.selectedProtocol == .openvpn {
                    self.connectOVPN()
                } else {
                    self.connectWG()
                }
            case .connecting:
                self.disconnect()
            case .disconnecting:
//                self.connectIKEv2()
                if appConstants.selectedProtocol == .openvpn {
                    self.connectOVPN()
                } else {
                    self.connectWG()
                }
        }
        
    }
    func connectWG(){
        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
            if InternetStatus{
                let serverPort = appConstants.selectedPortAndProtocolWG
                let clientPrivateKey: String = appConstants.privateKey
                let clientAddress: String = appConstants.localIp
                let serverPublicKey = appConstants.selectedServer?.wg?.first(where: { $0.port == Int(serverPort) })?.publicKey
                let serverAddress = appConstants.selectedServer?.ip
                    //                    self.disconnect()
                    //                    self.view.makeToast("Sorry cann't connect to this protocol.", duration: 0.5, position: .bottom)
                    //                    return   }
                let dns1 = userDefaults.string(forKey: DefaultDns1) ?? ""
                let dns2 = userDefaults.string(forKey: DefaultDns2) ?? ""
                UserDefaults.shared.set(appConstants.selectedServer?.ip ?? "", forKey: UserDefaults.Key.hostIP)
                UserDefaults.shared.set(dns1, forKey: UserDefaults.Key.DefaultDns1)
                UserDefaults.shared.set(dns2, forKey: UserDefaults.Key.DefaultDns2)
                
                var dnsArray = [dns1,dns2]
                UserDefaults.shared.set(userDefaults.bool(forKey: DnsEnabled), forKey: UserDefaults.Key.DnsEnabled)
                UserDefaults.shared.set(userDefaults.bool(forKey: AntiTracker), forKey: UserDefaults.Key.AntiTracker)
                if userDefaults.bool(forKey: AntiTracker){
                    dnsArray[0] =  appConstants.selectedServer?.dns1 ?? dns1
                    dnsArray[1] =  appConstants.selectedServer?.dns2 ?? dns2
                    UserDefaults.shared.set( appConstants.selectedServer?.dns1 ?? dns1, forKey: UserDefaults.Key.AntiTrackerDNS1)
                    UserDefaults.shared.set( appConstants.selectedServer?.dns2 ?? dns2, forKey: UserDefaults.Key.AntiTrackerDNS2)
                } else if userDefaults.bool(forKey: DnsEnabled) {
                    if let dnsServers = userDefaults.object(forKey: ResolvedDNSInsideVPN) as? [String]  {
                        dnsArray = dnsServers
                        UserDefaults.shared.set(dnsArray, forKey: UserDefaults.Key.ResolvedDNSInsideVPN)
                    }
                }
                let customDNS = userDefaults.string(forKey: CustomDNS) ?? ""
                let dnsProtocol =  userDefaults.string(forKey: CustomDNSProtocol) ?? ""
                let privateKey = userDefaults.string(forKey: PrivateKey) ?? ""
                UserDefaults.shared.set(customDNS, forKey: UserDefaults.Key.CustomDNS)
                UserDefaults.shared.set(dnsProtocol, forKey: UserDefaults.Key.CustomDNSProtocol)
                UserDefaults.shared.set(privateKey, forKey: UserDefaults.Key.PrivateKey)
                
                guard let cfg = WireGuard.AppConfiguration.make(
                    "\(appName) WireGuard",
                    appGroup: appGroup,
                    clientPrivateKey: clientPrivateKey,
                    clientAddress: clientAddress,
                    serverPublicKey: serverPublicKey!,
                    serverAddress: serverAddress!,
                    serverPort: serverPort, dnsArray: dnsArray
                ) else {
                    print("Configuration incomplete")
                    return
                }
                
                Task {
                    try await vpn.reconnect(
                        WIREGURADtunnelIdentifier,
                        configuration: cfg,
                        extra: nil,
                        isKillSwitchEnabled:  userDefaults.bool(forKey: KillSwitch),
                        after: .seconds(0)
                    )
                }
            }else {
                    //                self.showNoInternetMessage(self)
            }
        })
    }
    func connectOVPN() {
        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
            if InternetStatus  {
                let credentials = OpenVPN.Credentials(userDefaults.string(forKey: UserName) ?? "testing", userDefaults.string(forKey: Password) ?? "testing")
                let cert =  ApiManager.shared.serversDetails?.openvpn?.certificate ?? ""
                let selectedPortAndProtocol = appConstants.selectedPortAndProtocolOVPN
                let remotes = "remote \(appConstants.selectedServer?.ip ?? "") \(selectedPortAndProtocol)"
                let updatedCertWithRemotes = cert.replacingOccurrences(of: "[REMOTES]", with: remotes)
                let dns1 = userDefaults.string(forKey: DefaultDns1) ?? ""
                let dns2 = userDefaults.string(forKey: DefaultDns2) ?? ""
                var dnsArray = [dns1,dns2]
                if userDefaults.bool(forKey: AntiTracker){
                    dnsArray[0] = appConstants.selectedServer?.dns1 ?? dns1
                    dnsArray[1] = appConstants.selectedServer?.dns2 ?? dns2
                } else if userDefaults.bool(forKey: DnsEnabled) {
                    if let dnsServers = userDefaults.object(forKey: ResolvedDNSInsideVPN) as? [String]  {
                        dnsArray = dnsServers
                    }
                }
                cfg = OpenVPN.AppConfiguration.makeUsingAttributes(
                    title: "\(appName) OpenVPN",
                    appGroup: appGroup,
                    configurationString: updatedCertWithRemotes, dnsServers: dnsArray
                )
                cfg?.username = credentials.username
                let passwordReference: Data
                do {
                    passwordReference = try keychain.set(password: credentials.password, for: credentials.username, context: OVPNtunnelIdentifier)
                } catch {
                    print("Keychain failure: \(error)")
                    return
                }
                Task {
                    var extra = NetworkExtensionExtra()
                    extra.passwordReference = passwordReference
                    try await vpn.reconnect(
                        OVPNtunnelIdentifier,
                        configuration: cfg!,
                        extra: extra,
                        isKillSwitchEnabled: userDefaults.bool(forKey: KillSwitch),
                        after: .seconds(0)
                    )
                }
            }else {
                    //                self.showNoInternetMessage(self)
            }
        })
        
        
    }
    func connectIKEv2() {
        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
            if InternetStatus  {
                let title = "\(appName) IKEv2"
                let username = "testing"
//                let username = userDefaults.string(forKey: UserName) ?? "testing"
                let password = "testing"
//                let password = userDefaults.string(forKey: Password) ?? "testing"
                let serverAddress = "ikev2.vpnlightning-panel.online"
//                let serverAddress = appConstants.selectedServer?.ip ?? "ikev2.vpnlightning-panel.online"
                let passwordReference: Data
                do {
                    passwordReference = try keychain.set(password: password, for: username, context: IKEv2TunnelIdentifier)
                } catch {
                    print("Keychain failure: \(error)")
                    return
                }
                Task {
                    vpnManager.loadFromPreferences(completionHandler: { error in
                        if ((error) != nil) {
                            print("Could not load VPN Configurations")
                            return;
                        }
                        vpnManager.protocolConfiguration = IKEv2.AppConfiguration.make(title, address: serverAddress, username: username, password: passwordReference, tunnelId: serverAddress)
                        vpnManager.localizedDescription = title
                        vpnManager.isEnabled = true
                        vpnManager.saveToPreferences(completionHandler: { (error:Error?) in
                            if (error != nil) {
                                print("Could not save VPN Configurations")
                                return
                            } else {
                                do {
                                    print("connecting ikev2")
                                    try vpnManager.connection.startVPNTunnel()
                                } catch let error {
                                    print("Error starting VPN Connection \(error.localizedDescription)");
                                }
                            }
                        })
                    })
                }
            }else {
                    //                self.showNoInternetMessage(self)
            }
        })
        
        
    }
    func backgroundColor() -> some View {
        switch connectionStatus {
            case .connected:
                return AnyView(Color.red)
            case .connecting, .disconnecting:
                return AnyView(ConnectingStateButton())
            case .disconnected:
                return AnyView(
                    LinearGradient(gradient: Gradient(colors: colorScheme == .light ? appConstants.gradientColors : [appConstants.gradientColors[1]]), startPoint: .leading, endPoint: .trailing)
                )
        }
    }
    func disconnect() {
        Task {
            await vpn.disconnect()
        }
    }
}
