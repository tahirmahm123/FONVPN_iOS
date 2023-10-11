/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Response : Codable {
	let auth : Bool?
	let active : Bool?
	let expired : Bool?
	let allowLogin : Bool?
	let expiry_date : String?
	let apiToken : String?
	let totalSessionsAllowed : Int?
	let loggedInSessions : Int?
	let activeSessions : [ActiveSessions]?
	let vpn_username : String?
	let vpn_password : String?
	let verified : Bool?
	let timestamp : Int?
	let is_paid : Bool?
	let email : String?
	let plan : String?
	let days : Int?
    let localIP : String?
	let uuid : String?

	enum CodingKeys: String, CodingKey {

		case auth = "auth"
		case active = "active"
		case expired = "expired"
		case allowLogin = "allowLogin"
		case expiry_date = "expiry_date"
		case apiToken = "ApiToken"
		case totalSessionsAllowed = "totalSessionsAllowed"
		case loggedInSessions = "loggedInSessions"
		case activeSessions = "activeSessions"
		case vpn_username = "vpn_username"
		case vpn_password = "vpn_password"
		case verified = "verified"
		case timestamp = "timestamp"
		case is_paid = "is_paid"
		case email = "email"
		case plan = "plan"
		case days = "days"
        case localIP = "localIP"
		case uuid = "uuid"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		auth = try values.decodeIfPresent(Bool.self, forKey: .auth)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
		expired = try values.decodeIfPresent(Bool.self, forKey: .expired)
		allowLogin = try values.decodeIfPresent(Bool.self, forKey: .allowLogin)
		expiry_date = try values.decodeIfPresent(String.self, forKey: .expiry_date)
		apiToken = try values.decodeIfPresent(String.self, forKey: .apiToken)
		totalSessionsAllowed = try values.decodeIfPresent(Int.self, forKey: .totalSessionsAllowed)
		loggedInSessions = try values.decodeIfPresent(Int.self, forKey: .loggedInSessions)
		activeSessions = try values.decodeIfPresent([ActiveSessions].self, forKey: .activeSessions)
		vpn_username = try values.decodeIfPresent(String.self, forKey: .vpn_username)
		vpn_password = try values.decodeIfPresent(String.self, forKey: .vpn_password)
		verified = try values.decodeIfPresent(Bool.self, forKey: .verified)
		timestamp = try values.decodeIfPresent(Int.self, forKey: .timestamp)
		is_paid = try values.decodeIfPresent(Bool.self, forKey: .is_paid)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		plan = try values.decodeIfPresent(String.self, forKey: .plan)
        days = Int(try values.decodeIfPresent(Double.self, forKey: .days) ?? 0.0)
        localIP = try values.decodeIfPresent(String.self, forKey: .localIP)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
	}

}
struct ActiveSessions : Codable, Identifiable {
    var id: Int
    let tokenId : Int?
    let details : Details?
    let last_used_at : String?
    let _last_used_at : String?
    let currentSession : Bool?

    enum CodingKeys: String, CodingKey {

        case tokenId = "tokenId"
        case details = "details"
        case last_used_at = "last_used_at"
        case _last_used_at = "_last_used_at"
        case currentSession = "currentSession"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .tokenId)!
        tokenId = try values.decodeIfPresent(Int.self, forKey: .tokenId)
        details = try values.decodeIfPresent(Details.self, forKey: .details)
        last_used_at = try values.decodeIfPresent(String.self, forKey: .last_used_at)
        _last_used_at = try values.decodeIfPresent(String.self, forKey: ._last_used_at)
        currentSession = try values.decodeIfPresent(Bool.self, forKey: .currentSession)
    }

}
struct Details : Codable {
    let name : String?
    let type : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case type = "type"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}
