import UIKit

struct Schedule: CustomStringConvertible {
    var title: String
    var note: String
    var startTime: Date
    var endTime: Date
    var categoryColor: UIColor
    
    var description: String {
        return "\(startTime)"
    }
}

extension Schedule {
    
    static func trainingSession(dayOfEvent: Date) -> Schedule {
        let note = "At Leisure Centre"
        let hour = [Int](0...23).randomValue()
        let  startTime = Calendar.current.date(byAdding: .hour, value: hour, to: dayOfEvent)!
        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
        return trainingSession(note: note, startTime: startTime, endTime: endTime)
    }
    
    static func trainingSession(note: String, startTime: Date, endTime: Date) -> Schedule {
        return Schedule(title: "Training", note: note, startTime: startTime, endTime: endTime, categoryColor: .red)
    }
}

extension Schedule {
    
    static func match(dayOfEvent: Date) -> Schedule {
        let note = "Home"
        let hour = [Int](0...23).randomValue()
        let startTime = Calendar.current.date(byAdding: .hour, value: hour, to: dayOfEvent)!
        let endTime = Calendar.current.date(byAdding: .hour, value: 1, to: startTime)!
        return match(note: note, startTime: startTime, endTime: endTime)
    }
    
    static func match(note: String, startTime: Date, endTime: Date) -> Schedule {
        return Schedule(title: "Match", note: note, startTime: startTime, endTime: endTime, categoryColor: .green)
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

class Schedules {
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    private let storage: [Schedule]
    
    static func empty() -> Schedules {
        return Schedules(data: [])
    }
    
    init(data: [Schedule]) {
        self.storage = data
    }
    
    subscript(_ date: Date) -> [Schedule] {
        let formatted: String = Schedules.dateFormatter.string(from: date)
        return storage.filter{Schedules.dateFormatter.string(from: $0.startTime) == formatted}
    }
    
    func hasEvent(for date: Date) -> Bool {
        return self[date].count > 0
    }
}

class SchedulePersistence {
    
    private var mockData: [Schedule] {
        var data:[Schedule] = []
        let userCalendar = Calendar.current
        let years: [Int] = Array(2019...2030)
        let months: [Int] = Array(1...12)
        years.forEach{ year in
            months.forEach{ month in
                var trainingDate = DateComponents()
                trainingDate.year = year
                trainingDate.month = month
                trainingDate.day = 11
                data.append(Schedule.trainingSession(dayOfEvent: userCalendar.date(from: trainingDate)!))
                
                var matchDate = DateComponents()
                matchDate.year = year
                matchDate.month = month
                matchDate.day = 15
                data.append(Schedule.match(dayOfEvent: userCalendar.date(from: matchDate)!))
            }
        }
        return data;
    }
    
    private func load(_ dateInterval: DateInterval) -> [Schedule] {
        return mockData.filter{s in
            dateInterval.contains(s.startTime)
        }
    }
    
    func load(dateInterval: DateInterval) -> Schedules {
        let data: [Schedule] = load(dateInterval)
        return Schedules(data: data)
    }
    
}
