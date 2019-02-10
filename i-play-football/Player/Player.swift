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

class PlayerPersistence {
    
    func findAll() -> [Player] {
        return try!dbQueue.read { db in
            try Player.all().order(Column("lastName"), Column("firstName")).fetchAll(db)
        }
    }
    
    func delete(player: inout Player) {
        return try! dbQueue.inDatabase { db in
            return try player.delete(db)
        }
    }
    
    func save(player: inout Player) {
        try! dbQueue.inDatabase { db in
            try player.save(db)
        }
    }
    
}

