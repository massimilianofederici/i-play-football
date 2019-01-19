//
//  Team.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 30/12/2018.
//  Copyright © 2018 Massimiliano Federici. All rights reserved.
//

import Foundation

struct Team: Codable {
    
    let name: String
    let coach: String
    let colour: String
    let notes: String?
    
    init(name: String, coach: String, colour: String, notes: String?) {
        self.name = name
        self.coach = coach
        self.colour = colour
        self.notes = notes
    }
    
    static func aTeam() -> Team {
        return Team(name: "", coach: "", colour: "#27ae60", notes: "")
    }
    
    func withName(_ teamName: String) -> Team {
        return Team(name: teamName, coach: self.coach, colour: self.colour, notes: self.notes)
    }
    
    func withCoach(_ coach: String) -> Team {
        return Team(name: self.name, coach: coach, colour: self.colour, notes: self.notes)
    }
    
    func withColour(_ colour: String) -> Team {
        return Team(name: self.name, coach: self.coach, colour: colour, notes: self.notes)
    }
    
    func withNotes(_ notes: String?) -> Team {
        return Team(name: self.name, coach: self.coach, colour: self.colour, notes: notes)
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

