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
    var id: UUID?
    
    init(firstName: String, lastName: String, dateOfBirth: Date?, preferredPosition: PlayerPosition?, id: UUID?) {
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.preferredPosition = preferredPosition
        self.id = id
    }
    
    static func aPlayer() -> Player {
        return Player(firstName: "", lastName: "", dateOfBirth: nil, preferredPosition: nil, id: nil)
    }
    
    private init(transient: Player) {
        self.firstName = transient.firstName
        self.lastName = transient.lastName
        self.dateOfBirth = transient.dateOfBirth
        self.preferredPosition = transient.preferredPosition
        self.id = UUID();
    }
    
    func isTransient() -> Bool{
        return self.id == nil;
    }
    
    func name() -> String {
        return "\(firstName) \(lastName)"
    }
    
    func withFirstName(_ firstName: String) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, id: self.id)
    }
    
    func withLastName(_ lastName: String) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, id: self.id)
    }
    
    func withDateOfBirth(_ dateOfBirth: Date) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, id: self.id)
    }
    
    func withPreferredPosition(_ preferredPosition: PlayerPosition) -> Player {
        return Player(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, preferredPosition: preferredPosition, id: self.id)
    }
    
    func withId() -> Player {
        return self.id != nil ? self : Player(transient: self)
    }
}

enum PlayerPosition: String, CaseIterable, Codable {
    case goalkeeper = "Goalkeeper"
    case defender = "Defender"
    case leftWing = "Left Wing"
    case rightWing = "Right Wing"
    case midfielder = "Midfielder"
    case striker = "Striker"
}

class PlayersPersistence {
    
    private let preferenceName = "players"
    private let preferences = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save(_ players: [Player]) {
        let encoded: Data? = try? encoder.encode(players.map{ p in p.withId()})
        encoded.map{data in
            preferences.setValue(data, forKey: preferenceName)
            preferences.synchronize()
        }
    }
    
    func load() -> [Player] {
        //        var players: [Player] = []
        //        let calendar = Calendar.current
        //        let dateComponents = DateComponents(calendar: calendar,
        //                                            year: 2009,
        //                                            month: 12,
        //                                            day: 13)
        //        players.append(Player(firstName: "Manny", lastName: "Federici", dateOfBirth: dateComponents.date!, preferredPosition: PlayerPosition.striker))
        //        players.append(Player(firstName: "Alfie", lastName: "PP", dateOfBirth: dateComponents.date!, preferredPosition: PlayerPosition.midfielder))
        //        let encoded: Data? = try? encoder.encode(players)
        //        encoded.map{data in
        //            preferences.setValue(data, forKey: preferenceName)
        //            preferences.synchronize()
        //        }
        //        return players
        return preferences.data(forKey: preferenceName).flatMap{ data in
            try? decoder.decode([Player].self, from: data)
            } ?? []
    }
}

