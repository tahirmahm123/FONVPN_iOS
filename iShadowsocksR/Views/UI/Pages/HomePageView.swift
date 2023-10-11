//
//  HomePageView.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 05/08/2023.
//  Copyright © 2023 DigitalD.Tech. All rights reserved.
//

import SwiftUI
import PotatsoLibrary
import CommUtils

struct HomePageView: View {
    @EnvironmentObject var appConstants: AppConstants
    @State var showingLocation = false
    @State var vpnStatus: VPNStatus = .off
    @State var loading: Bool = false
    @State var currentServer: Servers?
    @State var fastestServer: Servers?
    @State var recentServer: Servers?
    @State var currentLocation: LocationModel?
    @State var loadingLocation: Bool = true
    @State private var points: [CoordinateData] = []
    var headerBgColor: String {
        switch vpnStatus {
            case .off:
                return "VPNDisconnectedColor"
            case .connecting, .disconnecting:
                return "VPNProcessingColor"
            case .on:
                return "VPNConnectedColor"
        }
    }
    let vpnStatusChangeNotification = NotificationCenter.default
        .publisher(for: Notification.Name(rawValue: kProxyServiceVPNStatusNotification))
    let serverSelectionNotification = NotificationCenter.default
        .publisher(for: .ServerSelected)
    var borderWidth: CGFloat = 20
    var body: some View {
        NavigationView {
            Background(color: Color(UIColor.systemGray6)) {
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            switch vpnStatus {
                                case .off:
                                    Image(systemName: "shield.slash")
                                    Text("You are not secure!")
                                        .font(.system(size: 10))
                                case .connecting, .disconnecting:
                                    Image(systemName: "shield")
                                    Text(vpnStatus == .connecting ? "Connecting..." : "Disconnecting...")
                                        .font(.system(size: 10))
                                case .on:
                                    Image(systemName: "shield.lefthalf.filled")
                                    Text("You are secured now")
                                        .font(.system(size: 10))
                            }
                        }
                        .padding(.vertical, 4)
                        GeometryReader { geometry in
                            VStack {
                                HStack(spacing: 0) {
                                    Spacer()
                                    Text("Your Location:")
                                    if loadingLocation {
//                                        ActivityIndicator{ view in
//                                            view.style = .medium
//                                        }
                                        Text("Loading..")
                                    } else {
                                        Text("\(currentLocation != nil ? "\(currentLocation!.city ?? ""), \(currentLocation!.country ?? "")" : "Loading...")")
                                    }
                                    Spacer()
                                }
                                .font(Font.system(size: 12))
                                GeometryReader { geometry in
                                    MapWithCoordinates(points: $points, height: geometry.size.height, width: geometry.size.width)
                                        .frame(height: geometry.size.height)
                                }
                                Button(action: {
                                    if currentServer != nil {
                                        $loading.wrappedValue = true
                                        Task {
                                            let sockConfig = await ApiManager.shared.connectToSocks(serverId: currentServer?.id ?? 0, prevServerId: recentServer?.id, prevServerPort: userDefaults.integer(forKey: PreviousPort))
                                            VPN.switchVPN(ConfigurationHelper.shared.buildProxyConfiguration(
                                                host: currentServer!.ip,
                                                port: sockConfig?.port ?? 0,
                                                authScheme: sockConfig?.method ?? "chacha20-ietf-poly1305",
//                                                password: "1McDS2yBoJMZPSld"), completion: { err in
                                                password: sockConfig?.password ?? ""), completion: { err in
                                                if err == nil {
                                                    DispatchQueue.main.async {
                                                        $loading.wrappedValue = false
                                                    }
                                                    print("Connected")
                                                } else {
                                                    print(err!)
                                                }
                                            })
                                        }
                                        
                                    }
                                }) {
                                    ConnectionButton(vpnStatus: $vpnStatus, loading: $loading)
                                }
                                .padding(2)
                                NavigationLink(destination: LocationsView(isShowing: $showingLocation), isActive: $showingLocation) {
                                    HStack {
                                        if currentServer == nil {
                                            Text("Tap to select Server")
                                                .font(Font.system(size: 13).weight(.semibold))
                                        }else{
                                            Image(currentServer?.country_code ?? "")
                                                .resizable()
                                                .frame(width: 35, height: 35)
                                            VStack(alignment: .leading) {
                                                Text(currentServer?.name ?? "No Servers Selected")
                                                    .font(Font.system(size: 13).weight(.semibold))
                                                Text("Tap to change Locaion")
                                                    .font(Font.system(size: 10).weight(.medium))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    .padding()
                                    .background(Color(UIColor.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(8)
                        }
                    }
                    .background(LinearGradient(colors: [Color(headerBgColor).opacity(0.2), Color.clear], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 0, y: 1)))
                    .padding(0)
                    .cornerRadius(8)
                    
                    VStack {
                        HStack(spacing: 20) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Image(systemName: "bolt")
                                    Text("Fastest Locations")
                                        .font(Font.system(size: 10).weight(.medium))
                                        .foregroundColor(.gray)
                                    Text(fastestServer?.name ?? "Loading...")
                                        .font(Font.system(size: 13).weight(.semibold))
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(8)
                            HStack {
                                VStack(alignment: .leading) {
                                    Image(systemName: "clock.arrow.circlepath")
                                    Text("Recent Locations")
                                        .font(Font.system(size: 10).weight(.medium))
                                        .foregroundColor(.gray)
                                    Text(recentServer?.name ?? "-")
                                        .font(Font.system(size: 13).weight(.semibold))
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(8)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack {
                        Image(systemName: "globe.americas")
                        VStack(alignment: .leading) {
                            Text("Current IP Address")
                                .font(Font.system(size: 10).weight(.medium))
                                .foregroundColor(.gray)
                            if loadingLocation {
                                Text("Loading..").font(Font.system(size: 13).weight(.semibold))
                            } else {
                                Text(currentLocation?.ip ?? "Loading...")
                                    .font(Font.system(size: 13).weight(.semibold))
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .navigationBarItems(leading: AppLogo(logoHeight: 24, fontSize: 18, varient: .light))
                .navigationBarItems(trailing: NavigationLink(destination: SettingsScreen()) {
                    Image(systemName: "gear")
                })
                .navigationBarItems(trailing: NavigationLink(destination: NotificationScreen()) {
                    Image(systemName: "bell")
                })
                
                .onReceive(serverSelectionNotification) { (notification: Notification) in
                    currentServer = appConstants.selectedServer
                    recentServer = appConstants.recentServer
                }
                .onReceive(vpnStatusChangeNotification) { (notification: Notification) in
                    print("VPN Status Changed Notification")
                    vpnStatus = Manager.sharedManager.vpnStatus
                    print("Status: \(Manager.sharedManager.vpnStatus)")
                    do {
                        print(try String(contentsOf: AppProfile.sharedSocksConfUrl(), encoding: .utf8))
                    }catch{
                        print("Error reading File")
                    }
                    if vpnStatus == .on || vpnStatus == .off {
                        updateLocation()
                    }
//                    print("VPNStatusDidChange: \(notification.vpnStatus)")
//                    connectionStatus = notification.vpnStatus
//                    vpnStatus = notification.vpnStatus
//                    switch (notification.vpnStatus) {
//                        case .connected, .connecting:
//                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
//                            let serverId = userDefaults.integer(forKey: appConstants.selectedProtocol == .openvpn ? LastSelectedServerOVPN : LastSelectedServerWG)
//                            NotificationCenter.default.post(name: .FocusOnMap, object: nil, userInfo: ["id": serverId])
//                        case .disconnected, .disconnecting:
//                            NotificationCenter.default.post(name: .FocusOnMap, object: nil, userInfo: ["id": 0])
//                    }
//                    NotificationCenter.default.post(name: .VPNTimer, object: self, userInfo: [
//                        "Status": connectionStatus
//                    ])
//                    if shouldReconnect && connectionStatus == .connecting {
//                        $shouldReconnect.wrappedValue = false
//                    }
//                    if shouldReconnect && connectionStatus == .disconnected {
//                        if appConstants.selectedProtocol == .openvpn {
//                            self.connectOVPN()
//                        } else {
//                            self.connectWG()
//                        }
//                    }
                }
            }
        }
        .onAppear(perform: {
            Manager.sharedManager.postMessage()
            vpnStatus = Manager.sharedManager.vpnStatus
            currentServer = appConstants.selectedServer
            fastestServer = appConstants.fastestServer
            recentServer = appConstants.recentServer
            updateLocation()
        })
    }
    
    func updateLocation() {
        $loadingLocation.wrappedValue = true
        appConstants.location(completion: {
            $currentLocation.wrappedValue = appConstants.currentLocation
            print(appConstants.currentLocation as Any)
            let location = appConstants.currentLocation
            $points.wrappedValue = [CoordinateData(id: 0, name: (location?.city ?? (location?.country ?? "")), latitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0, x: 0, y: 0)]
            $loadingLocation.wrappedValue = false
        })
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
