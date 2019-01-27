import UIKit

struct Schedule {
    var title: String
    var note: String
    var startTime: Date
    var endTime: Date
    var categoryColor: UIColor
    var dayOfTheEvent: Date
}

// random events
extension Schedule {
    init(fromStartDate: Date) {
        title = ["Meet Willard", "Buy a milk", "Read a book"].randomValue()
        note = ["hurry", "In office", "In New york city"].randomValue()
        categoryColor = [.red, .orange, .purple, .blue, .black].randomValue()
        
        let hour = [Int](0...23).randomValue()
        startTime = Calendar.current.date(byAdding: .hour, value: hour, to: fromStartDate)!
        endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
        dayOfTheEvent = Calendar.current.startOfDay(for: startTime)
    }
}


extension Schedule : Equatable {
    static func ==(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.startTime == rhs.startTime
    }
}

extension Schedule : Comparable {
    static func <(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.startTime < rhs.startTime
    }
}
