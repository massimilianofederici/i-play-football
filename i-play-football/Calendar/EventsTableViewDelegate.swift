import Foundation
import UIKit

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDate: Date = calendarView.selectedDates.first!
        let event: Event = events[selectedDate][indexPath.row]
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "editEvent", sender: event)
        }
    }
}
