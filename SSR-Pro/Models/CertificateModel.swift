//
//  CertificateModel.swift
//  Vulture VPN
//
//  Created by Personal on 14/07/2022.
//

import Foundation

struct CertificateModel : Codable {
    let message : String?
    let data : CertificateData?

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CertificateData.self, forKey: .data)
    }

}

struct CertificateData : Codable {
    let config : String?

    enum CodingKeys: String, CodingKey {

        case config = "config"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        config = try values.decodeIfPresent(String.self, forKey: .config)
    }

}
