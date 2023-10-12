
import Foundation
import Foundation
enum DNSProtocolType: String {
    
    case doh
    case dot
    case plain
    
    static func getServerURL(address: String) -> String {
        guard !address.trim().isEmpty else {
            return ""
        }
        
        var serverURL = address
        
        if !address.hasPrefix("https://") {
            serverURL = "https://\(serverURL)"
        }
        
        if let url = URL.init(string: serverURL) {
            if url.path.deletingPrefix("/").isEmpty {
                serverURL = "\(serverURL.deletingSuffix("/"))/dns-query"
            }
        }
        
        return serverURL
    }
    
    static func getServerName(address: String) -> String {
        var serverName = address
        
        if !address.hasPrefix("https://") {
            serverName = "https://\(serverName)"
        }
        
        if let url = URL.init(string: serverName) {
            if let host = url.host {
                do {
                    let ipAddress = try CIDRAddress(stringRepresentation: host)
                    return ipAddress?.ipAddress ?? address
                } catch {}
                
                return host
            }
        }
        
        return address
    }
    
    static func getServerToResolve(address: String) -> String {
        var serverName = address
        
        if !address.hasPrefix("https://") {
            serverName = "https://\(serverName)"
        }
        
        if let serverURL = URL.init(string: serverName) {
            if let host = serverURL.host {
                do {
                    let ipAddress = try CIDRAddress(stringRepresentation: host)
                    return ipAddress?.ipAddress ?? address
                } catch {}
                
                return serverURL.getTopLevelSubdomain()
            }
        }
        
        return address
    }
    
    static func sanitizeServer(address: String) -> String {
        return address.trim().deletingPrefix("https://").deletingPrefix("tls://")
    }
    
    static func preferred() -> DNSProtocolType {
        guard !userDefaults.bool(forKey: AntiTracker) else {
            return .plain
        }
        
        return DNSProtocolType.init(rawValue: userDefaults.string(forKey: CustomDNSProtocol) ??  "plain") ?? .plain
    }
    
    static func preferredSettings() -> DNSProtocolType {
        return DNSProtocolType.init(rawValue: userDefaults.string(forKey: CustomDNSProtocol) ??  "plain") ?? .plain
    }
    
    static func save(preferred: DNSProtocolType) {
        userDefaults.setValue(preferred.rawValue, forKey: CustomDNSProtocol)
    }
    
}
