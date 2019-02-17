import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    let calendarCellIdentifier = "calendarCell"
    let eventCellIdentifier = "eventDetail"
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var todayButton: UIBarButtonItem!
    
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showToday()
    }
    
    @IBAction func showToday() {
        let today: Date = Date()
        prefetchEvents(from: today)
        calendarView.scrollToDate(today, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.select(date: today)
        }
    }
    
    func prefetchEvents(from: Date) {
        events = try!dbQueue.read { db in
            try Event.within(DateInterval(start: from.startOfMonth(), end: from.endOfMonth())).fetchAll(db)
        }
    }
    
    func select(date: Date) {
        self.calendarView.selectDates([date])
        self.updateViewTitle()
        self.adjustCalendarViewHeight()
    }
    
    private func setup() {
        let calendarCellView = UINib(nibName: "CalendarCell", bundle: Bundle.main)
        calendarView.register(calendarCellView, forCellWithReuseIdentifier: calendarCellIdentifier)
        let tableCellView = UINib(nibName: "EventTableViewCell", bundle: Bundle.main)
        tableView.register(tableCellView, forCellReuseIdentifier: eventCellIdentifier)
    }
    
    private func adjustCalendarViewHeight() {
        let higher = calendarView.visibleDates().outdates.count < 7
        separatorViewTopConstraint.constant = higher ? 0 : -calendarView.frame.height / CGFloat(6)
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    private func updateViewTitle() {
        let startDate: Date = calendarView.visibleDates().monthDates.first!.date
        navigationItem.title = dateFormatter.string(from: startDate)
    }
    
}
