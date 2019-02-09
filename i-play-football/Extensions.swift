//
//  Extensions.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 26/01/2019.
//  Copyright © 2019 Massimiliano Federici. All rights reserved.
//

import Foundation

extension Date {
    func isThisMonth() -> Bool {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "yyyy MM"
        
        let dateString = monthFormatter.string(from: self)
        let currentDateString = monthFormatter.string(from: Date())
        return dateString == currentDateString
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}

extension Array {
    func randomValue() -> Element {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}

public extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var categories: [U: [Iterator.Element]] = [:]
        for element in self {
            let key = key(element)
            if categories[key] == nil {
                categories[key] = [element]
            }
            else {
                categories[key]?.append(element)
            }
        }
        
        return categories
    }
}
