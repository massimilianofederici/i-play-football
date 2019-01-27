import Foundation

struct Team: Codable {
    var name: String
    var coach: String?
    var colour: String?
    var notes: String?
}

extension Team {
    
    static func aTeam() -> Team {
        return Team(name: "", coach: "", colour: "#27ae60", notes: "")
    }
}

class TeamPersistence {
    
    private let preferenceName = "team"
    private let preferences = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save(team: Team) {
        let encoded: Data? = try? encoder.encode(team)
        encoded.map{data in
            preferences.setValue(data, forKey: preferenceName)
            preferences.synchronize()
        }
    }
    
    func load() -> Team {
        return preferences.data(forKey: preferenceName).flatMap{ data in
            try? decoder.decode(Team.self, from: data)
        } ?? Team.aTeam()
    }
}

