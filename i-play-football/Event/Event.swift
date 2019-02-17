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
        let endTime = Calendar.current.date(byAdding: .hour, value: 2, to: day)
        return Event(title: "", note: "", startTime: day.atThisTime(), endTime: endTime!, categoryColor: UIColor.red.hexString(), location: "", id: nil, type: EventType.match)
    }
}

enum EventType: String, CaseIterable, Codable {
    case match = "Match"
    case training = "Training Session"
    
    static func fromDescription(term: String?) -> EventType? {
        return EventType.allCases.first(where: { p in p.rawValue == term})
    }
    
    func color() -> UIColor {
        switch self {
        case .match:
            return .red
        case .training:
            return .green
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
