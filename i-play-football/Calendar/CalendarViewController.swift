import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    let calendarCellIdentifier = "calendarCell"
    let scheduleCellIdentifier = "scheduleDetail"
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var todayButton: UIBarButtonItem!
    
    var schedules: [Schedule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showToday()
    }
    
    @IBAction func showToday() {
        let today: Date = Date()
        prefetchSchedules(from: today)
        calendarView.scrollToDate(today, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.select(date: today)
        }
    }
    
    func prefetchSchedules(from: Date) {
        schedules = try!dbQueue.read { db in
            try Schedule.within(DateInterval(start: from.startOfMonth(), end: from.endOfMonth())).fetchAll(db)
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
        let tableCellView = UINib(nibName: "ScheduleTableViewCell", bundle: Bundle.main)
        tableView.register(tableCellView, forCellReuseIdentifier: scheduleCellIdentifier)
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
