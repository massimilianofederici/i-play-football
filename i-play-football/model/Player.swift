//
//  Player.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 12/01/2019.
//  Copyright © 2019 Massimiliano Federici. All rights reserved.
//

import Foundation

struct Player: Codable, Comparable {
    
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.name() < rhs.name()
    }
    
    let firstName: String
    let lastName: String
    let dateOfBirth: Date?
    let preferredPosition: PlayerPosition?
    let profilePicture: Data?
    var id: UUID?
    
    init(firstName: String, lastName: String,
         dateOfBirth: Date?,
         preferredPosition: PlayerPosition?,
         profilePicture: Data?,
         id: UUID?) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.preferredPosition = preferredPosition
        self.profilePicture = profilePicture
        self.id = id
    }
    
    static func aPlayer() -> Player {
        return Player(firstName: "", lastName: "", dateOfBirth: nil, preferredPosition: nil, profilePicture: nil, id: nil)
    }
    
    init(transient: Player) {
        self.firstName = transient.firstName
        self.lastName = transient.lastName
        self.dateOfBirth = transient.dateOfBirth
        self.preferredPosition = transient.preferredPosition
        self.profilePicture = transient.profilePicture
        self.id = UUID();
    }
    
    func isTransient() -> Bool{
        return self.id == nil;
    }
    
    func name() -> String {
        return "\(firstName) \(lastName)"
    }
    
    func withFirstName(_ firstName: String) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, profilePicture: self.profilePicture, id: self.id)
    }
    
    func withLastName(_ lastName: String) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, profilePicture: self.profilePicture, id: self.id)
    }
    
    func withDateOfBirth(_ dateOfBirth: Date?) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, profilePicture: self.profilePicture, id: self.id)
    }
    
    func withPreferredPosition(_ preferredPosition: PlayerPosition?) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, profilePicture: self.profilePicture, id: self.id)
    }
    
    func withProfilePicture(_ profilePicture: Data?) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, profilePicture: profilePicture, id: self.id)
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
        let encoded: Data? = try? encoder.encode(players.map{ p in
            p.isTransient() ? Player(transient: p) : p
        })
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

