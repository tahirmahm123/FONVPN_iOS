

import Foundation
struct RegisterUserModel : Codable {
    let token : String?
    let email : String?
    let emailVerified : Bool?
    let message : String?
    let errors : Errors?
    
    enum CodingKeys: String, CodingKey {

        case message = "message"
        case errors = "errors"
        case token = "token"
        case email = "email"
        case emailVerified = "emailVerified"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        emailVerified = try values.decodeIfPresent(Bool.self, forKey: .emailVerified)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        errors = try values.decodeIfPresent(Errors.self, forKey: .errors)
    }

}
