import Foundation
import UIKit

extension CalendarViewController: UITableViewDataSource {
    
    @IBAction func addEvent() {
        print("new event")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: eventCellIdentifier, for: indexPath) as! EventTableViewCell
        cell.selectionStyle = .none
        calendarView.selectedDates.first.map{cell.event = events[$0][indexPath.row]}
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = calendarView.selectedDates.first.map{events[$0].count} ?? 0
        return count
    }
}
