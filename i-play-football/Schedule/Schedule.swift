import UIKit
import GRDB

struct Schedule: Codable, FetchableRecord, MutablePersistableRecord {
    var title: String
    var note: String
    var startTime: Date
    var endTime: Date
    var categoryColor: String
    var id: Int?
}

extension Schedule {
    
    static func trainingSession(note: String, startTime: Date, endTime: Date) -> Schedule {
        return Schedule(title: "Training", note: note, startTime: startTime, endTime: endTime, categoryColor: UIColor.red.hexString(), id: nil)
    }
}

extension Schedule {
    
    static func match(note: String, startTime: Date, endTime: Date) -> Schedule {
        return Schedule(title: "Match", note: note, startTime: startTime, endTime: endTime, categoryColor: UIColor.green.hexString(), id: nil)
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
    
    private func load(_ interval: DateInterval) -> [Schedule] {
        return try!dbQueue.read { db in
            try Schedule.filter(Column("startTime") > interval.start && Column("endTime") < interval.end).fetchAll(db)
        }
    }
    
    func load(dateInterval: DateInterval) -> Schedules {
        let data: [Schedule] = load(dateInterval)
        return Schedules(data: data)
    }
    
}
