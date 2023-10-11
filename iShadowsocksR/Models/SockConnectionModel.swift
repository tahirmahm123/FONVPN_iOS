//
//  SockConnectionModel.swift
//  iShadowsocksR
//
//  Created by Tahir M. on 29/09/2023.
//  Copyright © 2023 DigitalD.Tech. All rights reserved.
//

import Foundation
struct SockConnectionModel : Codable {
    let port: Int?
    let method: String?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case port = "port"
        case method = "method"
        case password = "password"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        port = try values.decodeIfPresent(Int.self, forKey: .port)
        method = try values.decodeIfPresent(String.self, forKey: .method)
        password = try values.decodeIfPresent(String.self, forKey: .password)
    }
    
}
struct SockDisconnectModel : Codable {
    let message : String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}
