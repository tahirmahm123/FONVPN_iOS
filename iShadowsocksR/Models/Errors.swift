

import Foundation
struct Errors : Codable {
	let first_name : [String]?
	let last_name : [String]?
	let email : [String]?
	let password : [String]?

	enum CodingKeys: String, CodingKey {

		case first_name = "first_name"
		case last_name = "last_name"
		case email = "email"
		case password = "password"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		first_name = try values.decodeIfPresent([String].self, forKey: .first_name)
		last_name = try values.decodeIfPresent([String].self, forKey: .last_name)
		email = try values.decodeIfPresent([String].self, forKey: .email)
		password = try values.decodeIfPresent([String].self, forKey: .password)
	}

}
