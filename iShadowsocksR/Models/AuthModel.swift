//
//  AuthModel.swift
//  Vulture VPN
//
//  Created by Personal on 13/07/2022.
//

import Foundation
struct AuthModel : Codable {
    let response : Response?
    let message : String?
    let email : String?
    let state : Bool?

    enum CodingKeys: String, CodingKey {

        case response = "response"
        case message = "message"
        case state = "state"
        case email = "email"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        response = try values.decodeIfPresent(Response.self, forKey: .response)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        state = try values.decodeIfPresent(Bool.self, forKey: .state)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }

}
