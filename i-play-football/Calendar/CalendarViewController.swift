import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        return formatter
    }()
    let calendarCellIdentifier = "calendarCell"
    let scheduleCellIdentifier = "scheduleDetail"
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    
    var schedules: Schedules = Schedules.empty()
    let persistence: SchedulePersistence = SchedulePersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewNibs()
        let today: Date = Date()
        prefetchSchedules(from: today)
        calendarView.scrollToDate(today, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.select(date: today)
        }
    }
    
    func prefetchSchedules(from: Date) {
        let end = from.endOfMonth()
        let start = from.startOfMonth()
        schedules = persistence.load(dateInterval: DateInterval(start: start, end: end))
    }
    
    func select(date: Date) {
        self.calendarView.selectDates([date])
        self.updateViewTitle()
        self.adjustCalendarViewHeight()
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupViewNibs() {
        let calendarCellView = UINib(nibName: "CalendarCell", bundle: Bundle.main)
        calendarView.register(calendarCellView, forCellWithReuseIdentifier: calendarCellIdentifier)
        let tableCellView = UINib(nibName: "ScheduleTableViewCell", bundle: Bundle.main)
        tableView.register(tableCellView, forCellReuseIdentifier: scheduleCellIdentifier)
    }
    
    private func adjustCalendarViewHeight() {
        let higher = calendarView.visibleDates().outdates.count < 7
        separatorViewTopConstraint.constant = higher ? 0 : -calendarView.frame.height / CGFloat(6)
    }
    
    private func updateViewTitle() {
        let startDate: Date = calendarView.visibleDates().monthDates.first!.date
        let year = Calendar.current.component(.year, from: startDate)
        let month = Calendar.current.component(.month, from: startDate)
        navigationItem.title = "\(dateFormatter.monthSymbols[month-1]) \(year)"
    }
}
