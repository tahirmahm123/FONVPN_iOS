//
//  ServerListModel.swift
//  Vulture VPN
//
//  Created by Personal on 13/07/2022.
//

import Foundation


struct DnsServers : Codable {
    let dns1 : String?
    let dns2 : String?

    enum CodingKeys: String, CodingKey {

        case dns1 = "dns1"
        case dns2 = "dns2"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dns1 = try values.decodeIfPresent(String.self, forKey: .dns1)
        dns2 = try values.decodeIfPresent(String.self, forKey: .dns2)
    }

}
struct Default : Codable {
    let dns1 : String?
    let dns2 : String?

    enum CodingKeys: String, CodingKey {

        case dns1 = "dns1"
        case dns2 = "dns2"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dns1 = try values.decodeIfPresent(String.self, forKey: .dns1)
        dns2 = try values.decodeIfPresent(String.self, forKey: .dns2)
    }

}
struct AdsBlocker : Codable {
    let dns1 : String?
    let dns2 : String?

    enum CodingKeys: String, CodingKey {

        case dns1 = "dns1"
        case dns2 = "dns2"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dns1 = try values.decodeIfPresent(String.self, forKey: .dns1)
        dns2 = try values.decodeIfPresent(String.self, forKey: .dns2)
    }

}

struct ServersData : Codable {
    let servers : [ServerByCountry]?
    let dnsServers : DnsServers?
    let openvpn : Openvpn?
    let wireguard : [Int]?

    enum CodingKeys: String, CodingKey {

        case servers = "servers"
        case dnsServers = "dnsServers"
        case openvpn = "openvpn"
        case wireguard = "wireguard"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        servers = try values.decodeIfPresent([ServerByCountry].self, forKey: .servers)
        dnsServers = try values.decodeIfPresent(DnsServers.self, forKey: .dnsServers)
        openvpn = try values.decodeIfPresent(Openvpn.self, forKey: .openvpn)
        wireguard = try values.decodeIfPresent([Int].self, forKey: .wireguard)
    }

}

class ServerByProtocol : Codable {
    let openvpnServers : [ServerByCountry]?
    let wgServers : [ServerByCountry]?
    
    enum CodingKeys: String, CodingKey {
        
        case openvpnServers = "openvpn"
        case wgServers = "wireguard"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        openvpnServers = try values.decodeIfPresent([ServerByCountry].self, forKey: .openvpnServers)
        wgServers = try values.decodeIfPresent([ServerByCountry].self, forKey: .wgServers)
    }
    
}


class ServerByCountry : Codable, Identifiable {
    let id: String?
    let flag : String?
    let country : String?
    let servers : [Servers]?
    
    enum CodingKeys: String, CodingKey {
        
        case flag = "flag"
        case country = "country"
        case servers = "servers"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
        id = try values.decodeIfPresent(String.self, forKey: .flag)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        servers = try values.decodeIfPresent([Servers].self, forKey: .servers)
    }
    
        // Implement the RandomAccessCollection protocol requirements
    typealias Element = Servers // Replace YourElementType with the type contained in the servers array
    
    var startIndex: Int { servers!.startIndex }
    var endIndex: Int { servers!.endIndex }
    
    subscript(position: Int) -> Servers {
        return servers![position]
    }
    
    func index(after i: Int) -> Int {
        return servers!.index(after: i)
    }
}



class Servers: Codable, Hashable, Equatable {
    var pingMs: Int?
    let id: Int
    let name: String
    let ip: String
    let port: Int
    let flag: String
    let premium: Bool
    let country: String
    let country_code: String
    let dns1: String?
    let dns2: String?
    let location: Location?
    let openvpn: [Openvpn]?
    let wg: [Wg]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case ip = "ip"
        case port = "port"
        case flag = "flag"
        case premium = "premium"
        case country = "country"
        case country_code = "country_code"
        case openvpn = "openvpn"
        case wg = "wg"
        case dns1 = "dns1"
        case dns2 = "dns2"
        case location = "location"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        ip = try values.decode(String.self, forKey: .ip)
        port = try values.decode(Int.self, forKey: .port)
        flag = try values.decode(String.self, forKey: .flag)
        premium = try values.decode(Bool.self, forKey: .premium)
        country = try values.decode(String.self, forKey: .country)
        country_code = try values.decode(String.self, forKey: .country_code)
        dns1 = try values.decodeIfPresent(String.self, forKey: .dns1)
        dns2 = try values.decodeIfPresent(String.self, forKey: .dns2)
        openvpn = try values.decodeIfPresent([Openvpn].self, forKey: .openvpn)
        wg = try values.decodeIfPresent([Wg].self, forKey: .wg)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Servers, rhs: Servers) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Location : Codable {
    let longitude : Float?
    let latitude : Float?

    enum CodingKeys: String, CodingKey {
        case longitude = "longitude"
        case latitude = "latitude"
    }

    init(longitude: Float?, latitude: Float?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        longitude = try Float(values.decodeIfPresent(String.self, forKey: .longitude)!)
        latitude = try Float(values.decodeIfPresent(String.self, forKey: .latitude)!)
    }

}
struct Ports : Codable {
    let vpnprotocol : String?
    let port : Int?

    enum CodingKeys: String, CodingKey {

        case vpnprotocol = "protocol"
        case port = "port"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        vpnprotocol = try values.decodeIfPresent(String.self, forKey: .vpnprotocol)
        port = try values.decodeIfPresent(Int.self, forKey: .port)
    }

}
struct Openvpn : Codable {
    let certificate : String?
    let ports : [Ports]?

    enum CodingKeys: String, CodingKey {

        case certificate = "certificate"
        case ports = "ports"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        certificate = try values.decodeIfPresent(String.self, forKey: .certificate)
        ports = try values.decodeIfPresent([Ports].self, forKey: .ports)
    }

}


struct Wg : Codable {
    let publicKey : String?
    let allowedIPs : String?
    let port : Int?

    enum CodingKeys: String, CodingKey {

        case publicKey = "PublicKey"
        case allowedIPs = "AllowedIPs"
        case port = "port"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        publicKey = try values.decodeIfPresent(String.self, forKey: .publicKey)
        allowedIPs = try values.decodeIfPresent(String.self, forKey: .allowedIPs)
        port = try values.decodeIfPresent(Int.self, forKey: .port)
    }

}
