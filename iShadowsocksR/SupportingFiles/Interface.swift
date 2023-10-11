
import Foundation
import Network

struct Interface {
    
    // MARK: - Properties -
    
    var addresses: String?
    var listenPort: Int
    var privateKey: String?
    var dns: String?
    
    var publicKey: String? {
//        if let privateKeyString = privateKey, let privateKey = Data(base64Encoded: privateKeyString) {
//            var publicKey = Data(count: 32)
//            privateKey.withUnsafeUInt8Bytes { privateKeyBytes in
//                publicKey.withUnsafeMutableUInt8Bytes { mutableBytes in
//                    curve25519_derive_public_key(mutableBytes, privateKeyBytes)
//                }
//            }
//            return publicKey.base64EncodedString()
//        } else {
            return nil
//        }
    }
    
    // MARK: - Initialize -
    
    init(addresses: String? = nil, listenPort: Int = 0, privateKey: String? = nil, dns: String? = nil) {
        self.addresses = addresses
        self.listenPort = listenPort
        self.privateKey = privateKey
        self.dns = dns
    }
    
    init?(_ dict: NSDictionary) {
        if let ipAddress = dict.value(forKey: "ip_address") as? String {
            self.addresses = ipAddress
        } else {
//            log(error: "Cannot create Interface: no 'ip_address' field specified")
            return nil
        }
        
        listenPort = 0
    }
    
    // MARK: - Methods -
    
    static func generatePrivateKey() -> String {
//        var privateKey = Data(count: 32)
//        privateKey.withUnsafeMutableUInt8Bytes { mutableBytes in
//            curve25519_generate_private_key(mutableBytes)
//        }
//        
//        return privateKey.base64EncodedString()
        return "prvKey"
    }
    
    static func getAddresses(ipv4: String?, ipv6: String?) -> String {
        guard let ipv4 = ipv4 else {
            return ""
        }
        
        guard let ipv6 = ipv6 else {
            return ipv4
        }
        
        let ipv6Address = IPv6Address("\(ipv6.components(separatedBy: "/")[0])\(ipv4)")
        
        return "\(ipv4),\(ipv6Address?.debugDescription ?? "")/64"
    }
    
}
extension Data {
    
    func withUnsafeUInt8Bytes<R>(_ body: (UnsafePointer<UInt8>) -> R) -> R {
        return self.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> R in
            let bytes = ptr.bindMemory(to: UInt8.self)
            return body(bytes.baseAddress!) // might crash if self.count == 0
        }
    }
    
    mutating func withUnsafeMutableUInt8Bytes<R>(_ body: (UnsafeMutablePointer<UInt8>) -> R) -> R {
        return self.withUnsafeMutableBytes { (ptr: UnsafeMutableRawBufferPointer) -> R in
            let bytes = ptr.bindMemory(to: UInt8.self)
            return body(bytes.baseAddress!) // might crash if self.count == 0
        }
    }
    
}
