//
//  LogoutDeviceModel.swift
//  Vulture VPN
//
//  Created by Personal on 16/07/2022.
//

import Foundation


struct LogoutDeviceModel : Codable {
    let totalSessionsAllowed : Int?
    let loggedInSessions : Int?
    let activeSessions : [ActiveSessions]?

    enum CodingKeys: String, CodingKey {

        case totalSessionsAllowed = "totalSessionsAllowed"
        case loggedInSessions = "loggedInSessions"
        case activeSessions = "activeSessions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalSessionsAllowed = try values.decodeIfPresent(Int.self, forKey: .totalSessionsAllowed)
        loggedInSessions = try values.decodeIfPresent(Int.self, forKey: .loggedInSessions)
        activeSessions = try values.decodeIfPresent([ActiveSessions].self, forKey: .activeSessions)
    }

}
