import UIKit
import GRDB

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
}()

class Schedule: Codable, FetchableRecord, MutablePersistableRecord {
    var title: String
    var note: String
    var startTime: Date
    var endTime: Date
    var categoryColor: String
    var id: Int?
    
    static func findWithin(_ interval: DateInterval) -> QueryInterfaceRequest<Schedule> {
        return Schedule.filter(Column("startTime") >= interval.start && Column("endTime") <= interval.end)
    }
}

extension Array where Element: Schedule {

    subscript(_ date: Date) -> [Schedule] {
        let formatted: String = dateFormatter.string(from: date)
        return self.filter{dateFormatter.string(from: $0.startTime) == formatted}
    }
    
    func hasEvent(for date: Date) -> Bool {
        return self[date].count > 0
    }
}
