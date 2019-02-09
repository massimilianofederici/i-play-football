import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter
    }()
    let calendarCellIdentifier = "calendarCell"
    let scheduleCellIdentifier = "scheduleDetail"
    let calendarDateFormat = "yyyy MM dd"
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    
    var schedules: Schedules = Schedules.empty()
    let persistence: SchedulePersistence = SchedulePersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewNibs()
        let today: Date = Date()
        select(date: today, animate: false)
    }
    
    func select(date: Date, animate: Bool) {
        prefetchSchedules(from: date)
        calendarView.scrollToDate(date, triggerScrollToDateDelegate: false, animateScroll: animate, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.updateViewTitle()
            self.adjustCalendarViewHeight()
            self.calendarView.selectDates([date], triggerSelectionDelegate: true)
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
    
    private func prefetchSchedules(from: Date) {
        let end = Calendar.current.date(byAdding: .month, value: 2, to: from.endOfMonth())
        let start = Calendar.current.date(byAdding: .month, value: -2, to: from.startOfMonth())
        schedules = persistence.load(dateInterval: DateInterval(start: start!, end: end!))
    }
    
    private func updateViewTitle() {
        let startDate: Date = calendarView.visibleDates().monthDates.first!.date
        let year = Calendar.current.component(.year, from: startDate)
        let month = Calendar.current.component(.month, from: startDate)
        navigationItem.title = "\(dateFormatter.monthSymbols[month-1]) \(year)"
    }
}
