import Foundation
import GRDB

struct Player: Codable, FetchableRecord, MutablePersistableRecord {
    
    private static let FirstName = Column("firstName")
    private static let LastName = Column("lastName")
    private static let Id = Column("id")

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
    
    static func orderByName() -> QueryInterfaceRequest<Player> {
        return Player.order(Player.LastName, Player.FirstName).select(Player.LastName, Player.FirstName, Player.Id)
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
