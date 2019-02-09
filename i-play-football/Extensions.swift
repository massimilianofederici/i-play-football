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
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
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
