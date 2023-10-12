//
//  AppConstants.swift
//  VPN-Lightning
//
//  Created by Tahir M. on 28/05/2023.
//  Copyright © 2023 Onion Tech Ltd. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit
import NetworkExtension

class AppConstants: ObservableObject {
    static let shared = AppConstants()
    let gradientColors = [Color("PrimaryGradientColor1"), Color("PrimaryGradientColor2")]
    @Published var loggedIn: Bool
    @Published var userName: String
    @Published var isExpired: String
    @Published var expiryDate: String
    @Published var timeStamp: Double
    @Published var totalDevicesAllowed: Int
    @Published var loggedInDevices: Int
    @Published var plan: String
    @Published var activeDevices: [ActiveSessions]
    @Published var currentLocation: LocationModel?
    static let locationQueue = DispatchQueue(label: "LocationFetchQueue")
    var currentDevice: Bool {
        if activeDevices.count > 0 {
            let currentD = activeDevices.filter({ device in
                return device.currentSession!
            }).first
            if currentD != nil {
                return currentD!.currentSession!
            }else{
                return false
            }
        } else {
            return false
        }
    }
    var daysLeft: Int {
        return numberOfDays(fromUnixTimestamp: timeStamp)
    }
    @Published var selectedProtocol: ProtocolType {
        didSet {
            print("Setting New Heights")
            userDefaults.set(selectedProtocol.rawValue, forKey: SelectedProtocol)
        }
    }
    
    var selectedServer: Servers? {
        var server =  ApiManager.shared.serversList?.first(where: {$0.id == userDefaults.integer(forKey: LastSelectedServer)})
        if server == nil {
            server = ApiManager.shared.serversList?.first
            userDefaults.setValue(server?.id, forKey: LastSelectedServer)
        }
        print("selected server \(String(describing: server?.id))")
        return server
    }
    
    var fastestServer: Servers? {
        let ip = ApiManager.shared.serverPing.max(by:{$0.value > $1.value})?.key
        return ApiManager.shared.serversList?.filter {
            return $0.ip == ip
        }.first
    }
    var recentServer: Servers? {
        let id = userDefaults.integer(forKey: RecentSelectedServer)
        let server = ApiManager.shared.serversList?.filter {
            return $0.id == id
        }.first
        print("reccent server \(String(describing: server?.id))")
        return server
    }
    
    // Wireguard Details
    @Published var publicKey: String
    @Published var privateKey: String
    @Published var localIp: String
    @Published var rotationDays: Int {
        didSet {
            userDefaults.set(rotationDays, forKey: RotationDays)
        }
    }
    @Published var keyGeneratedDate: Date
    var nextGenerationDate: Date {
        return Calendar.current.date(byAdding: .day, value: rotationDays, to: keyGeneratedDate)!
    }
    
    init() {
        loggedIn = userDefaults.bool(forKey: isLogedIn) 
        userName = userDefaults.string(forKey: UserName) ?? "Testing"
        isExpired = userDefaults.string(forKey: isPaidUser) ?? "Testing"
        expiryDate = userDefaults.string(forKey: ExpiryDate) ?? "Testing"
        timeStamp = userDefaults.double(forKey: TimeStamp)
        plan = "\(ApiManager.shared.usersData?.plan ?? "Premium")"
        loggedInDevices = ApiManager.shared.usersData?.loggedInSessions ?? 1
        totalDevicesAllowed = ApiManager.shared.usersData?.totalSessionsAllowed ?? 5
        activeDevices = ApiManager.shared.usersData?.activeSessions ?? []
            // Choose Protocol
        selectedProtocol = ProtocolType(rawValue: userDefaults.integer(forKey: SelectedProtocol))!
            // Wireguard Details
        publicKey = userDefaults.string(forKey: PublicKey) ?? ""
        privateKey = userDefaults.string(forKey: PrivateKey) ?? ""
        localIp = userDefaults.string(forKey: LocalIp) ?? ""
        rotationDays = userDefaults.integer(forKey: RotationDays)
        keyGeneratedDate = userDefaults.object(forKey: KeyGeneratedDate) as? Date ?? Date()
    }
    
    func refreshData() {
        loggedIn = userDefaults.bool(forKey: isLogedIn) 
        userName = userDefaults.string(forKey: UserName) ?? "Testing"
        isExpired = userDefaults.string(forKey: isPaidUser) ?? "Testing"
        expiryDate = userDefaults.string(forKey: ExpiryDate) ?? "Testing"
        timeStamp = userDefaults.double(forKey: TimeStamp)
        plan = "\(ApiManager.shared.usersData?.plan ?? "Premium")"
        loggedInDevices = ApiManager.shared.usersData?.loggedInSessions ?? 1
        totalDevicesAllowed = ApiManager.shared.usersData?.totalSessionsAllowed ?? 5
        activeDevices = ApiManager.shared.usersData?.activeSessions ?? []
            // Choose Protocol
        selectedProtocol = ProtocolType(rawValue: userDefaults.integer(forKey: SelectedProtocol))!
            // Wireguard Details
        publicKey = userDefaults.string(forKey: PublicKey) ?? ""
        privateKey = userDefaults.string(forKey: PrivateKey) ?? ""
        localIp = userDefaults.string(forKey: LocalIp) ?? ""
        rotationDays = userDefaults.integer(forKey: RotationDays)
        keyGeneratedDate = userDefaults.object(forKey: KeyGeneratedDate) as? Date ?? Date()
    }
    
    func updateSelectedProtocol(_ newProtocol: ProtocolType) {
        self.selectedProtocol = newProtocol
    }
    
    func updateUserDetails() {
        Task {
            let _ = await ApiManager.shared.updateUserData()
            self.refreshData()
        }
    }
    
    func logoutAllDevices(completion: @escaping () -> Void ) {
        ApiManager.shared.logoutAllDevices(completion: {(isDevicesLoggedOut, activeDevices) -> Void in
            self.loggedInDevices = activeDevices?.loggedInSessions ?? 1
            self.totalDevicesAllowed = activeDevices?.totalSessionsAllowed ?? 5
            self.activeDevices = activeDevices?.activeSessions ?? []
            completion()
        })
    }
    
    func logoutDevice(_ id: Int, completion: @escaping () -> Void ) {
//        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
//            if InternetStatus{
        ApiManager.shared.logoutSpecifDevice(isCurrentDevice: false, deviceToken: id, completion: {(isLoggedOut, activeDevices) -> Void in
            self.loggedInDevices = activeDevices?.loggedInSessions ?? 1
            self.totalDevicesAllowed = activeDevices?.totalSessionsAllowed ?? 5
            self.activeDevices = activeDevices?.activeSessions ?? []
            completion()
        })
//            } else {
//                self.showNoInternetMessage(self)
//            }
//        })
    }
    func logout(completion: @escaping () -> Void ) {
//        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
//            if InternetStatus{
        Task {
            if await ApiManager.shared.logoutUser() {
                userDefaults.set(nil, forKey: LocalIp)
                userDefaults.set(false, forKey: isLogedIn)
                    //                        self.disconnect()
                
                DispatchQueue.main.async {
                    completion()
                }
                NotificationCenter.default.post(name: .LoggedOutUser, object: nil)
            }
        } 
//            } else {
//                self.showNoInternetMessage(self)
//            }
//        })
    }
    func delete(completion: @escaping () -> Void ) {
//        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
//            if InternetStatus{
                ApiManager.shared.deleteUser(completion: { (success) -> Void in
                    if success {
                        userDefaults.set(nil, forKey: LocalIp)
                        userDefaults.set(false, forKey: isLogedIn)
//                        self.disconnect()
                        DispatchQueue.main.async {
                            completion()
                        }
                        NotificationCenter.default.post(name: .LoggedOutUser, object: nil)
                    }
                })
//            } else {
//                self.showNoInternetMessage(self)
//            }
//        })
    }
    func plans(completion: @escaping ([SKProduct], String) -> Void ) {
//        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
//            if InternetStatus{
                ApiManager.shared.fetchPlans(completion: { (success) -> Void in
                    if success {
                        let planWithMaxSavePercent = ApiManager.shared.plansData!.max(by: { $0.savePercent ?? 0 < $1.savePercent ?? 0 })
                        let popular = planWithMaxSavePercent?.identifier ?? ""
                        IAPManager.shared.fetchAvailableProducts(completion: { products in
                            completion(products, popular)
                        })
                    }
                })
//            } else {
//                self.showNoInternetMessage(self)
//            }
//        })
    }
    
    func location(completion: @escaping () -> Void ) {
//        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
//            if InternetStatus{
        AppConstants.locationQueue.sync {
            ApiManager.shared.updateLocation(completion: { (success) -> Void in
                DispatchQueue.main.async {
                    if success {
                        self.currentLocation = ApiManager.shared.currentLocation
                    }else {
                        print("Failed to update Location")
                    }
                    completion()
                }
            })
        }
//            } else {
//                self.currentLocation = nil
//            }
//        })
    }
    
    
    func resetDefaults() {
        userDefaults.setValue(nil, forKey: UserName)
        userDefaults.setValue(nil, forKey: Password)
        userDefaults.setValue(nil, forKey: ApiKey)
        userDefaults.setValue(nil, forKey: ExpiryDate)
        userDefaults.setValue(nil, forKey: SubscriptionPlan)
        userDefaults.setValue(nil, forKey: CERT)
        userDefaults.setValue(nil, forKey: isPaidUser)
        userDefaults.setValue(nil, forKey: isLogedIn)
        userDefaults.setValue(nil, forKey: LastTimeSaved)
        userDefaults.setValue(nil, forKey: LastSelectedServer)
        userDefaults.setValue(nil, forKey: DiagnosticLogs)
        userDefaults.setValue(nil, forKey: SelectedProtocol)
        userDefaults.setValue(nil, forKey: SelectedProtocolSegment)
        userDefaults.setValue(nil, forKey: DnsOverHT)
        userDefaults.setValue(nil, forKey: DnsEnabled)
        userDefaults.setValue(nil, forKey: CustomDNS)
        userDefaults.setValue(nil, forKey: CustomDNSProtocol)
        userDefaults.setValue(nil, forKey: ResolvedDNSInsideVPN)
        userDefaults.setValue(nil, forKey: ResolvedDNSOutsideVPN)
        userDefaults.setValue(nil, forKey: AntiTracker)
        userDefaults.setValue(nil, forKey: KillSwitch)
        userDefaults.setValue(nil, forKey: SelectRandomServer)
        userDefaults.setValue(nil, forKey: AutoSelectFastServer)
        userDefaults.setValue(nil, forKey: TimeInterval)
        userDefaults.setValue(nil, forKey: SelectedProtocol)
        userDefaults.setValue(nil, forKey: SelectedApperance)
        userDefaults.setValue(nil, forKey: QuickSettingsServer)
    }
    
    func generateKeys(){
        InternetAvailability.shared.connectivityStatus(completion: { (InternetStatus) -> Void in
            if InternetStatus{
                if userDefaults.string(forKey: LocalIp) == nil  || userDefaults.string(forKey: LocalIp) == ""{
                    InterfaceForKey.privateKey = Interface.generatePrivateKey()
                    let privateKey = InterfaceForKey.privateKey ?? ""
                    let publicKey = InterfaceForKey.publicKey ?? ""
//                    self.showHUD()
                    ApiManager.shared.generateWireGuardKeys(publicKey: publicKey, privateKey: privateKey, completion: { success in
//                        self.hideHUD()
                        if success{
                            print("Generated")
                        }
                    })
                }
            }else {
//                self.showNoInternetMessage(self)
                print("internet issue")
            }
        })
    }
    
    func validateNotificationPermission(action: @escaping (() -> Void), onSuccess: @escaping (() -> Void) = {}) {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                action()
            } else {
                onSuccess()
            }
        })
    }
    
    func validateVPNConfiguration(action: @escaping (() -> Void), onSuccess: @escaping (() -> Void) = {}) {
        NETunnelProviderManager.loadAllFromPreferences { managers, error in
            if error == nil {
                if managers!.count < 1 {
                    action()
                } else {
                    onSuccess()
                }
            }
        }
    }
    
    func numberOfDays(fromUnixTimestamp timestamp: TimeInterval) -> Int {
        let currentDate = Date()
        let unixDate = Date(timeIntervalSince1970: timestamp)
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: currentDate, to: unixDate)
        
        if let days = dateComponents.day {
            return days
        } else {
            return 0
        }
    }
}
