//
//  DNSSettingsView.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 28/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct DNSSettingsView: View {
    @EnvironmentObject var appConstants: AppConstants
    @State private var isEnabled = false
    @State private var dnsOverHTTPSorTLS = false
    @State private var dnsServer = ""
    @State private var selectedProtocol = 0
    @State private var resolveIP = "x.x.x.x"
    @State private var serverAddressLabel = "Server URL"
    @State private var serverAddress = ""
    @State private var textFieldFocused = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertSubtitle = ""
    @State private var alertDismiss: (() -> Void) = {
        
    }
    
    let updateResolvedDNSInsideVPN = NotificationCenter.default.publisher(for: .UpdateResolvedDNSInsideVPN)
    let resolvedDNSError = NotificationCenter.default.publisher(for: .ResolvedDNSError)
    var onDismiss: (() -> Void)
    var body: some View {
        NavigationView {
            List {
                Section(footer: VStack(alignment: .leading) {
                    Text("Configure custom DNS server, which is used when connected to VPN. Supported only for OpenVPN and WireGuard protocols.")
//                        .font(Font.custom("Urbanist", size: 14))
                    Text("Note: Antitracker will override this setting when enabled.")
//                        .font(Font.custom("Urbanist", size: 14))
                }) {
                    Button(action: {
                        isEnabled.toggle()
                    }) {
                        HStack {
                            Text("Enabled")
                                .font(Font.custom("Urbanist", size: 16))
                                .foregroundColor(Color(UIColor.label))
                            Spacer()
                            Toggle(isOn: $isEnabled, label: {
                                Text("")
                            })
                        }
                    }
                }
                Section(
                    header: Text("DNS Server"),
                    footer: Text("When Specified, VPN Client will used provided DNS server when Connected to the VPN.")
                ) {
                    HStack {
                        TextField("Enter DNS Server", text: $dnsServer, onEditingChanged: { (editingChanged) in
                            if editingChanged {
                                $textFieldFocused.wrappedValue = true
                            } else {
                                $textFieldFocused.wrappedValue = false
                            }
                        })
                        
                        if textFieldFocused {
                            Button(action: {
                                $dnsServer.wrappedValue = UIPasteboard.general.string ?? ""
                            }) {
                                Image("clipboard-text")
                            }
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Resolved IP")
                            .font(Font.custom("Urbanist", size: 16.0))
                        Text(resolveIP)
                            .font(Font.custom("Urbanist", size: 14.0))
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("DNS over HTTPS/TLS")
                            .font(Font.custom("Urbanist", size: 16))
                        Spacer()
                        Toggle(isOn: $dnsOverHTTPSorTLS.animation(), label: {
                            Text("")
                        })
                    }
                    if dnsOverHTTPSorTLS {
                        VStack(alignment: .leading) {
                            Text("Server IP Address")
                                .font(Font.custom("Urbanist", size: 16.0))
                            Text(serverAddress)
                                .font(Font.custom("Urbanist", size: 14.0))
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Protocol")
                                .font(Font.custom("Urbanist", size: 16.0))
                            Spacer()
                            Picker("", selection: $selectedProtocol) {
                                Text("DoH").tag(0)
                                Text("DoT").tag(1)
                            }
                            .pickerStyle(.segmented)
                            .frame(minWidth: 0, maxWidth: 100)
                        }
                    }
                }
            }
            .navigationBarTitle("DNS Settings", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                if textFieldFocused {
                    UIApplication.shared.endEditing()
                    dnsServer = userDefaults.string(forKey: CustomDNS) ?? ""
                }else{
                    onDismiss()
                }
            }) {
                if textFieldFocused {
                    Text("Cancel")
                }else {
                    Image(systemName: "xmark")
                }
            })
            .navigationBarItems(trailing: Button(action: {
                if textFieldFocused {
                    saveAddress()
                    UIApplication.shared.endEditing()
                }
            }) {
                if textFieldFocused {
                    Text("Save")
                        .foregroundColor(Color("ThemeColor"))
                        .font(Font.custom("Urbanist", size: 16))
                } else {
                    Text("")
                }
            })
            .accentColor(Color("AccentColor"))
            .onAppear(perform: {
                basicUpdates()
            })
            .onChange(of: dnsOverHTTPSorTLS) { newValue in
                let preferred: DNSProtocolType =  selectedProtocol == 1 ? .dot : .doh
                DNSProtocolType.save(preferred: newValue ? preferred : .plain)
                if userDefaults.bool(forKey: DnsEnabled) {
//                    evaluateReconnect(sender: self.dnsIpAddressTextField, senderSwitch: sender)
                }
            }
            .onChange(of: selectedProtocol) { newValue in
                let preferred: DNSProtocolType = newValue == 1 ? .dot : .doh
                DNSProtocolType.save(preferred: preferred)
                if userDefaults.bool(forKey: DnsEnabled) {
//                    evaluateReconnect(sender: self.dnsIpAddressTextField, senderSegment: sender)
                }
                basicUpdates()
            }
            .onChange(of: isEnabled) { newValue in
                let server = dnsServer
                if server.isEmpty {
                    showAlert(title: "", subTitle: "Please enter DNS server info", dismiss: {
                        $isEnabled.wrappedValue = false
                    })
                    return
                }
                if server.lowercased().contains("nextdns") && userDefaults.integer(forKey: SelectedProtocol) == 1{
                    showAlert(title: "Error!", subTitle: "Custom DNS is not available for nextdns for wireguard", dismiss: {
                        $isEnabled.wrappedValue = false
                    })
                    return
                }
                userDefaults.set(isEnabled, forKey: DnsEnabled)
                if userDefaults.bool(forKey: DnsEnabled){
                    userDefaults.set(false, forKey: AntiTracker)
                }
//                evaluateReconnect(sender: sender, msg: "To apply the new settings, Evolve VPN needs to be reconnected. Antitracker will override this setting when enabled" , senderSwitch: sender)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertSubtitle),
                    dismissButton: .cancel(Text("OK"), action: alertDismiss)
                )
            }
            .onReceive(updateResolvedDNSInsideVPN) { (notification: Notification) in
                updateResolvedDNS()
            }
            .onReceive(resolvedDNSError) { (notification: Notification) in
                showAlert(title: "Error", subTitle: "Failed to resolve IP addresses for DNS server")
            }
        }
    }
    
    func saveAddress(isFromSwitch: Bool = false) {
        var server = dnsServer
        if server.lowercased().contains("nextdns") && appConstants.selectedProtocol == .wireguard {
            showAlert(title: "Error!", subTitle: "Custom DNS is not available for nextdns for wireguard", dismiss: {
                dnsServer = ""
            })
            return
        }
        server = DNSProtocolType.sanitizeServer(address: server)
        resolveIP = server
        
        if #available(iOS 14.0, *) {
            let serverToResolve = DNSProtocolType.getServerToResolve(address: server)
            DNSManager.saveResolvedDNS(server: serverToResolve, key: ResolvedDNSInsideVPN)
        }
        userDefaults.set(server,forKey: CustomDNS)
        if server.isEmpty {
            userDefaults.set(false, forKey: DnsEnabled)
            userDefaults.set([], forKey: ResolvedDNSInsideVPN)
            $isEnabled.wrappedValue = false
        }
        basicUpdates()
        if userDefaults.bool(forKey: DnsEnabled){
//            evaluateReconnect(sender: self.dnsIpAddressTextField)
        }
    }
    
    func basicUpdates() {
        let preferred = DNSProtocolType.preferredSettings()
        let customDNS = userDefaults.string(forKey: CustomDNS)
        $isEnabled.wrappedValue = userDefaults.bool(forKey: DnsEnabled)
        $dnsServer.wrappedValue = customDNS ?? ""
        $dnsOverHTTPSorTLS.wrappedValue = preferred != .plain
        $selectedProtocol.wrappedValue = preferred == .dot ? 1 : 0
        self.updateResolvedDNS()
        self.handleSegmentControl()
    }
    
    func updateResolvedDNS() {
        let resolvedDNS = userDefaults.value(forKey: ResolvedDNSInsideVPN) as? [String] ?? []
        resolveIP = resolvedDNS.count > 0 ? resolvedDNS.map { String($0) }.joined(separator: ", ") : "x.x.x.x"
    }
    
    func handleSegmentControl() {
        var dns = ""
        if let customDNS = userDefaults.string(forKey: CustomDNS) {
            dns = customDNS
        }
        if dns != ""{
            if selectedProtocol == 0 {
                $serverAddressLabel.wrappedValue = "Server URL"
                $serverAddress.wrappedValue = DNSProtocolType.getServerURL(address: dns)
            } else {
                $serverAddressLabel.wrappedValue = "Server Name"
                $serverAddress.wrappedValue = DNSProtocolType.getServerName(address: dns)
            }
        } else {
            if selectedProtocol == 0  {
                $serverAddressLabel.wrappedValue = "Server URL"
                $serverAddress.wrappedValue = "...."
            } else {
                $serverAddressLabel.wrappedValue = "Server Name"
                $serverAddress.wrappedValue = "...."
            }
        }
    }
    
    func showAlert(title: String, subTitle: String, dismiss: @escaping (() -> Void) = { }) {
        $alertTitle.wrappedValue = title
        $alertSubtitle.wrappedValue = subTitle
        $alertDismiss.wrappedValue = dismiss
        showAlert.toggle()
    }
}

struct DNSSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DNSSettingsView(onDismiss: {
            
        })
        .environmentObject(AppConstants.shared)
    }
}
