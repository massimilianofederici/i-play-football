import UIKit

class EventTableViewCell: UITableViewCell {

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
    
    var event: Event! {
        didSet {
            titleLabel.text = event.title
            noteLabel.text = event.note
            startTimeLabel.text = dateFormatter.string(from: event.startTime)
            endTimeLabel.text = dateFormatter.string(from: event.endTime)
            categoryLine.backgroundColor = UIColor(event.categoryColor)
        }
    }
}
