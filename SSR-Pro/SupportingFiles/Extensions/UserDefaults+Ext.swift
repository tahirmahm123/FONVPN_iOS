

import Foundation
extension UserDefaults {
    
    static var shared: UserDefaults {
        return UserDefaults(suiteName: Config.appGroup)!
    }
    struct Key {
        static let hostIP = "hostIP"
        static let DefaultDns1 = "defaultdns1"
        static let DefaultDns2 = "defaultdns2"
        static let AntiTracker = "AntiTracker"
        static let DnsEnabled = "dnsEnabled"
        static let AntiTrackerDNS1 = "antitrackerdns1"
        static let AntiTrackerDNS2 = "antitrackerdns2"
        static let ResolvedDNSInsideVPN = "ResolvedDNSInsideVPN"
        static let CustomDNSProtocol = "customDNSProtocol"
        static let CustomDNS = "customDNS"
        static let PrivateKey = "privateKey"
    }
    @objc dynamic var DefaultDns1: String {
        return string(forKey: Key.DefaultDns1) ?? ""
    }
    @objc dynamic var PrivateKey: String {
        return string(forKey: Key.PrivateKey) ?? ""
    }
    @objc dynamic var AntiTrackerDNS1: String {
        return string(forKey: Key.AntiTrackerDNS1) ?? ""
    }
    @objc dynamic var AntiTrackerDNS2: String {
        return string(forKey: Key.AntiTrackerDNS2) ?? ""
    }
    @objc dynamic var DefaultDns2: String {
        return string(forKey: Key.DefaultDns2) ?? ""
    }
    
    @objc dynamic var hostIP: String {
        return string(forKey: Key.hostIP) ?? ""
    }
    @objc dynamic var CustomDNS: String {
        return string(forKey: Key.CustomDNS) ?? ""
    }
    @objc dynamic var CustomDNSProtocol: String {
        return string(forKey: Key.CustomDNSProtocol) ?? ""
    }
    @objc dynamic var ResolvedDNSInsideVPN: [String]  {
        return stringArray(forKey: Key.ResolvedDNSInsideVPN) ?? []
    }
    @objc dynamic var DnsEnabled: Bool {
        return bool(forKey: Key.DnsEnabled)
    }
    @objc dynamic var AntiTracker: Bool {
        return bool(forKey: Key.AntiTracker)
    }
    
    
    
}
