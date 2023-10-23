//
//  SettingsUI.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 27/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var app: AppConstants
    
    @State private var selectedPort: String = ""
    @State private var isQuickConnectShown = false
    @State private var isChooseProtocolShown = false
    @State private var isDnsSettingsShown = false
    @State private var isAntiTrackerShown = false
    @State private var isConnectionLogsShown = false
    @State private var quickConnectCountry: ServerByCountry?
    @State private var antiTracker = false
    var body: some View {
        NavigationView {
            List() {
                Section(header: Text("Connectivity")) {
                    Button(action:  {
                        isQuickConnectShown.toggle()
                    }) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Quick-Connect")
                                .font(Font.system(size: 16))
                                .foregroundColor(Color(UIColor.label))
                            Text("Quick connect button on main screen will connect to: ")
                                .font(Font.system(size: 12))
                                .foregroundColor(.gray)
                            if quickConnectCountry != nil {
                                HStack {
                                    Image((quickConnectCountry?.flag)!)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .clipShape(Circle())
                                    Text((quickConnectCountry?.country)!)
                                        .font(Font.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    }
                    Button(action: {
                        isChooseProtocolShown.toggle()
                    }) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Protocol")
                                .font(Font.system(size: 16))
                                .foregroundColor(Color(UIColor.label))
                            Text("\(availableProtocols[app.selectedProtocol]!) \(selectedPort)")
                                .font(Font.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    }
                    Button(action: {
                        isDnsSettingsShown.toggle()
                    }) {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("DNS Servers")
                                .font(Font.system(size: 16))
                                .foregroundColor(Color(UIColor.label))
                            Text("Configure custom DNS server, which is used when connected to VPN")
                                .font(Font.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    }
                    Button(action: {
                        isAntiTrackerShown.toggle()
                    }) {
                        VStack(alignment: .leading) {
                            Text("Anti Tracker")
                                .font(Font.system(size: 16))
                                .foregroundColor(Color(UIColor.label))
                            Text("Configure ad, malware, tracker blocking")
                                .font(Font.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    }
                }
                Section(header: Text("Logging")
                    .font(Font.system(size: 14))
                ) {
                    Button(action: {
                        isConnectionLogsShown.toggle()
                    }) {
                        Text("Connection Logs")
                            .font(Font.system(size: 16))
                            .padding(EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4))
                            .foregroundColor(Color(UIColor.label))
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .large)
            .onAppear {
                antiTracker = userDefaults.AntiTracker
                UITableView.appearance().bounces = true
                selectedPort = getSelectedPort()
                quickConnectCountry = quickConnectServer()
            }
            .sheet(isPresented: $isQuickConnectShown) {
                QuickSettinngsView(visible: $isQuickConnectShown, onDismiss: {
                    quickConnectCountry = quickConnectServer()
                })
            }
            .sheet(isPresented: $isConnectionLogsShown) {
                ConnectionLogsView(visible: $isConnectionLogsShown)
            }
            .sheet(isPresented: $isChooseProtocolShown, onDismiss: {
                selectedPort = getSelectedPort()
            }) {
                ChooseProtocolView(onDismiss: {
                    isChooseProtocolShown.toggle()
                })
            }
            .sheet(isPresented: $isAntiTrackerShown) {
                AntiTrackerView(antiTrackerEnabled: $antiTracker, onDismiss: {
                    isAntiTrackerShown.toggle()
                })
            }
            .sheet(isPresented: $isDnsSettingsShown) {
                DNSSettingsView(onDismiss: {
                    isDnsSettingsShown.toggle()
                })
            }
        }
    }
    
    func serverData() -> [ServerByCountry]? {
        let selectedProtocol = userDefaults.object(forKey: SelectedProtocol) as? ProtocolType ?? .openvpn
        if selectedProtocol == .openvpn {
            return ApiManager.shared.groupedServersOVPN
        }else{
            return ApiManager.shared.groupedServersWG
        }
    }
    
    func getSelectedPort() -> String {
        if app.selectedProtocol == .openvpn {
            selectedPort = app.selectedPortAndProtocolOVPN
            print("Printing Selected Port : \(app.selectedPortAndProtocolOVPN)")
        } else if app.selectedProtocol == .wireguard {
            selectedPort = app.selectedPortAndProtocolWG
        } else {
            selectedPort = ""
        }
        return selectedPort
    }
    
    func quickConnectServer() -> ServerByCountry? {
        let data: [ServerByCountry]
        let quickFlag: String
        let selectedProtocol = userDefaults.object(forKey: SelectedProtocol) as? ProtocolType ?? .openvpn
        if selectedProtocol == .openvpn {
            data = ApiManager.shared.groupedServersOVPN!
            quickFlag = userDefaults.string(forKey: QuickSettingsServerOVPN)!
        }else{
            data = ApiManager.shared.groupedServersWG!
            quickFlag = userDefaults.string(forKey: QuickSettingsServerWG)!
        }
        let filtered = data.filter {(item: ServerByCountry) -> Bool in
            return item.flag == quickFlag
        }
        return filtered.first
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppConstants())
    }
}
