
import Foundation
struct RenewModel : Codable {
    let state : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case state = "state"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
