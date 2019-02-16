import Foundation
import GRDB

struct Player: Codable, FetchableRecord, MutablePersistableRecord {

    var firstName: String
    var lastName: String
    var dateOfBirth: Date?
    var preferredPosition: PlayerPosition?
    var profilePicture: Data?
    var notes: String?
    var id: Int?
    
    var name: String {
        return "\(firstName) \(lastName)"
    }
}

enum PlayerPosition: String, CaseIterable, Codable {
    case goalkeeper = "Goalkeeper"
    case defender = "Defender"
    case leftWing = "Left Wing"
    case rightWing = "Right Wing"
    case midfielder = "Midfielder"
    case striker = "Striker"
    
    static func fromDescription(term: String?) -> PlayerPosition? {
        return PlayerPosition.allCases.first(where: { p in p.rawValue == term})
    }
}
