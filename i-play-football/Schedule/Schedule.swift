import UIKit

struct Schedule {
    var title: String
    var note: String
    var startTime: Date
    var endTime: Date
    var categoryColor: UIColor
    var dayOfTheEvent: Date
}

//extension Schedule {
////    init(fromStartDate: Date) {
//////        title = ["Meet Willard", "Buy a milk", "Read a book"].randomValue()
////        note = ["hurry", "In office", "In New york city"].randomValue()
//////        categoryColor = [.red, .orange, .purple, .blue, .black].randomValue()
////
////        let hour = [Int](0...23).randomValue()
////        startTime = Calendar.current.date(byAdding: .hour, value: hour, to: fromStartDate)!
////        endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
////        dayOfTheEvent = Calendar.current.startOfDay(for: startTime)
////    }
//}

extension Schedule {
    
    static func trainingSession(dayOfEvent: Date) -> Schedule {
        let note = "At Leisure Centre"
        let hour = [Int](0...23).randomValue()
        let  startTime = Calendar.current.date(byAdding: .hour, value: hour, to: dayOfEvent)!
        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
        return trainingSession(note: note, startTime: startTime, endTime: endTime)
    }
    
    static func trainingSession(note: String, startTime: Date, endTime: Date) -> Schedule {
        return Schedule(title: "Training", note: note, startTime: startTime, endTime: endTime, categoryColor: .red, dayOfTheEvent: Calendar.current.startOfDay(for: startTime))
    }
}

extension Schedule {
    
    static func match(dayOfEvent: Date) -> Schedule {
        let note = "Home"
        let hour = [Int](0...23).randomValue()
        let  startTime = Calendar.current.date(byAdding: .hour, value: hour, to: dayOfEvent)!
        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
        return match(note: note, startTime: startTime, endTime: endTime)
    }
    
    static func match(note: String, startTime: Date, endTime: Date) -> Schedule {
        return Schedule(title: "Match", note: note, startTime: startTime, endTime: endTime, categoryColor: .green, dayOfTheEvent: Calendar.current.startOfDay(for: startTime))
    }
}

extension Schedule : Equatable, Comparable {
    static func ==(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.startTime == rhs.startTime
    }
    
    static func <(lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.startTime < rhs.startTime
    }
}

class SchedulePersistence {
    
    private func load(from: Date, to: Date) -> [Schedule] {
        var data:[Schedule] = []
        let today: Date = Calendar.current.startOfDay(for: from)
        data.append(Schedule.trainingSession(dayOfEvent: today))
        let date = Calendar.current.date(byAdding: .day, value: 5, to: today)
        data.append(Schedule.match(dayOfEvent: date!))
        return data
    }
    
    func load(from: Date) -> Dictionary<Date, [Schedule]> {
        let to:Date = Calendar.current.date(byAdding: .month, value: 1, to: from)!
        let data = load(from: from, to: to)
        return data.group{$0.dayOfTheEvent}
    }
    
}
