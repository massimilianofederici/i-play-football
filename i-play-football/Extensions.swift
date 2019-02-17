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
    
    func atThisTime() -> Date {
        let now: Date = Date()
        let hours = Calendar.current.dateComponents([.hour], from: now).hour!
        return Calendar.current.date(bySetting: .hour, value: hours, of: self)!
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
}
