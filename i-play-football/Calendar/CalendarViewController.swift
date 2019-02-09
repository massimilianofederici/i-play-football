import JTAppleCalendar

#warning("fix indicator for scheduled events")
class CalendarViewController: UIViewController {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter
    }()
    let calendarCellIdentifier = "calendarCell"
    let scheduleCellIdentifier = "scheduleDetail"
    let calendarDateFormat = "yyyy MM dd"
    let numberOfRowsInCalendar = 6
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    
    var schedules: Schedules = Schedules.empty()
    let persistence: SchedulePersistence = SchedulePersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewNibs()
        let today: Date = Date()
        self.getSchedules(from: today, to: Calendar.current.date(byAdding: .month, value: 2, to: today)!)
        calendarView.scrollToDate(today, triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.updateViewTitle()
            self.adjustCalendarViewHeight()
            self.calendarView.selectDates([today], triggerSelectionDelegate: true)
        }
    }
    
    func select(date: Date) {
        calendarView.scrollToDate(date, triggerScrollToDateDelegate: false, animateScroll: true, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
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
        separatorViewTopConstraint.constant = higher ? 0 : -calendarView.frame.height / CGFloat(numberOfRowsInCalendar)
    }
    
    func getSchedules(from: Date, to: Date) {
        schedules = persistence.load(from: from, to: to)
    }
    
    private func updateViewTitle() {
        let startDate: Date = calendarView.visibleDates().monthDates.first!.date
        let year = Calendar.current.component(.year, from: startDate)
        let month = Calendar.current.component(.month, from: startDate)
        navigationItem.title = "\(dateFormatter.monthSymbols[month-1]) \(year)"
    }
}
