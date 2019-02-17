import UIKit
import GRDB

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
}()

struct Event: Codable, FetchableRecord, MutablePersistableRecord {
    var title: String
    var note: String?
    var startTime: Date
    var endTime: Date
    var categoryColor: String
    var location: String
    var id: Int?
    var type: EventType
    
    static func within(_ interval: DateInterval) -> QueryInterfaceRequest<Event> {
        return Event.filter(Column("startTime") >= interval.start && Column("endTime") <= interval.end)
    }
}

extension Event {
    static func anEvent(day: Date) -> Event {
        let startTime: Date = day.atThisTime()
        let defaultDuration: Int = UserDefaults.standard.integer(forKey: "eventDuration")
        let endTime: Date = Calendar.current.date(byAdding: .minute, value: defaultDuration, to: startTime)!
        #warning("configure event type by default")
        let eventType: EventType = EventType.match
        return Event(title: "", note: "", startTime: startTime, endTime: endTime, categoryColor: eventType.color(), location: "", id: nil, type: eventType)
    }
}

enum EventType: String, CaseIterable, Codable {
    case match = "Match"
    case training = "Training Session"
    
    static func fromDescription(term: String?) -> EventType? {
        return EventType.allCases.first(where: { p in p.rawValue == term})
    }
    
    func color() -> String {
        switch self {
        case .match:
            return UIColor.red.hexString()
        case .training:
            return UIColor.green.hexString()
        }
    }
}

extension Array where Element == Event {

    subscript(_ date: Date) -> [Event] {
        let formatted: String = dateFormatter.string(from: date)
        return self.filter{dateFormatter.string(from: $0.startTime) == formatted}
    }
    
    func hasEvent(for date: Date) -> Bool {
        return self[date].count > 0
    }
}
