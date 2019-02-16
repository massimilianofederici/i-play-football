import UIKit
import GRDB

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
}()

class Event: Codable, FetchableRecord, MutablePersistableRecord {
    var title: String
    var note: String
    var startTime: Date
    var endTime: Date
    var categoryColor: String
    var id: Int?
    
    static func within(_ interval: DateInterval) -> QueryInterfaceRequest<Event> {
        return Event.filter(Column("startTime") >= interval.start && Column("endTime") <= interval.end)
    }
}

extension Array where Element: Event {

    subscript(_ date: Date) -> [Event] {
        let formatted: String = dateFormatter.string(from: date)
        return self.filter{dateFormatter.string(from: $0.startTime) == formatted}
    }
    
    func hasEvent(for date: Date) -> Bool {
        return self[date].count > 0
    }
}
