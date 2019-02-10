import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLine: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    var schedule: Schedule! {
        didSet {
            titleLabel.text = schedule.title
            noteLabel.text = schedule.note
            startTimeLabel.text = dateFormatter.string(from: schedule.startTime)
            endTimeLabel.text = dateFormatter.string(from: schedule.endTime)
            categoryLine.backgroundColor = UIColor(schedule.categoryColor)
        }
    }
}
