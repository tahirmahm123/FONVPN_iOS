//
//  LogoutModel.swift
//  Vulture VPN
//
//  Created by Personal on 16/07/2022.
//

import Foundation
struct LogoutModel : Codable {
    let message : String?

    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
