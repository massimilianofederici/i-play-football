import Foundation
import UIKit

extension CalendarViewController: UITableViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next : UINavigationController = segue.destination as! UINavigationController
        let eventDetailsController:EventViewController = next.topViewController as! EventViewController
        switch segue.identifier {
        case "newEvent":
            let newEvent = Event.anEvent(day: self.calendarView.selectedDates.first!)
            eventDetailsController.event = newEvent
        default:
            print("Invalid")
        }
    }
    
    @IBAction func cancelChanges(eventDetails: UIStoryboardSegue) {
    }
    
    @IBAction func saveOrUpdate(eventDetails: UIStoryboardSegue) {
        let detailsController:EventViewController = eventDetails.source as! EventViewController
        var event = detailsController.event!
        try! dbQueue.write { db in
            try event.save(db)
        }
        prefetchEvents(from: event.startTime.startOfMonth())
        select(date: event.startTime)
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
