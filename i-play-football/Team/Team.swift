import Foundation
import GRDB

struct Team: Codable, FetchableRecord, MutablePersistableRecord {
    var id: Int?
    var name: String
    var coach: String?
    var colour: String?
    var notes: String?
}

extension Team {
    
    static func aTeam() -> Team {
        return Team(id: nil, name: "", coach: "", colour: "#27ae60", notes: "")
    }
}
