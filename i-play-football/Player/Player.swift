import Foundation

class Player: Codable {

    var firstName: String
    var lastName: String
    var dateOfBirth: Date?
    var preferredPosition: PlayerPosition?
    var profilePicture: Data?
    var notes: String?
    var id: UUID?
    
    init(firstName: String, lastName:String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func name() -> String {
        return "\(firstName) \(lastName)"
    }
}

extension Player: Comparable, Equatable {
    
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.name() < rhs.name()
    }
    
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.name() == rhs.name()
    }
}

extension Player {
    
    func prepareForSave() {
        self.id = self.id ?? UUID()
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

class PlayersPersistence {
    
    private let preferenceName = "players"
    private let preferences = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save(_ players: [Player]) {
        players.forEach{ $0.prepareForSave() }
        let encoded: Data? = try? encoder.encode(players)
        encoded.map{data in
            preferences.setValue(data, forKey: preferenceName)
            preferences.synchronize()
        }
    }
    
    func load() -> [Player] {
        return preferences.data(forKey: preferenceName).flatMap{ data in
            try? decoder.decode([Player].self, from: data)
            } ?? []
    }
}

