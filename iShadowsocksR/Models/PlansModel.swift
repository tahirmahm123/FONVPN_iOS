
import Foundation
struct PlansModel : Codable {
    let plans : [PlanItemModel]?
    let subtitles : String?
    
    enum CodingKeys: String, CodingKey {
        
        case plans = "plans"
        case subtitles = "subtitles"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        plans = try values.decodeIfPresent([PlanItemModel].self, forKey: .plans)
        subtitles = try values.decodeIfPresent(String.self, forKey: .subtitles)
    }

}
struct PlanItemModel : Codable {
    let identifier : String?
    let days : Int?
    let savePercent : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case identifier = "identifier"
        case days = "days"
        case savePercent = "save"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try values.decodeIfPresent(String.self, forKey: .identifier)
        days = try values.decodeIfPresent(Int.self, forKey: .days)
        savePercent = try values.decodeIfPresent(Int.self, forKey: .savePercent)
    }
}
