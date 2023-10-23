//
//  UserDetailsModel.swift
//  Vulture VPN
//
//  Created by Personal on 14/07/2022.
//

import Foundation

struct LocationModel: Codable {
    let code: String?
    let country: String?
    let city: String?
    let latitude: Double?
    let longitude: Double?
    let ip: String?
    let isVPNConnected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case country = "country"
        case city = "city"
        case latitude = "latitude"
        case longitude = "longitude"
        case ip = "ip"
        case isVPNConnected = "is_vpn_connected"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        latitude = Double(try values.decodeIfPresent(String.self, forKey: .latitude) ?? "")
        longitude = Double(try values.decodeIfPresent(String.self, forKey: .longitude) ?? "")
        ip = try values.decodeIfPresent(String.self, forKey: .ip)
        isVPNConnected = try values.decodeIfPresent(Bool.self, forKey: .isVPNConnected)
    }
}

struct UserDetailsModel : Codable {
    let account : Bool?
    let plan : String?
    let active : Bool?
    let isFta : Bool?
    let timestamp : Int?
    let expired : Bool?
    let totalSessionsAllowed : Int?
    let expiry_date : String?
    let uuid : String?
    let loggedInSessions : Int?
    let activeSessions : [ActiveSessions]?
    let location: LocationModel?
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case plan = "plan"
        case active = "active"
        case isFta = "is_fta"
        case timestamp = "timestamp"
        case expired = "expired"
        case totalSessionsAllowed = "totalSessionsAllowed"
        case loggedInSessions = "loggedInSessions"
        case expiry_date = "expiry_date"
        case activeSessions = "activeSessions"
        case uuid = "uuid"
        case location = "location"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        account = try values.decodeIfPresent(Bool.self, forKey: .account)
        plan = try values.decodeIfPresent(String.self, forKey: .plan)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        isFta = try values.decodeIfPresent(Bool.self, forKey: .isFta)
        timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
        expired = try values.decodeIfPresent(Bool.self, forKey: .expired)
        totalSessionsAllowed = try values.decodeIfPresent(Int.self, forKey: .totalSessionsAllowed)
        loggedInSessions = try values.decodeIfPresent(Int.self, forKey: .loggedInSessions)
        activeSessions = try values.decodeIfPresent([ActiveSessions].self, forKey: .activeSessions)
        expiry_date = try values.decodeIfPresent(String.self, forKey: .expiry_date)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        location = try values.decodeIfPresent(LocationModel.self, forKey: .location)
    }
    
}
