import JTAppleCalendar

#warning("fix indicator for scheduled events")
class CalendarViewController: UIViewController {
    
    let calendarCellIdentifier = "calendarCell"
    let scheduleCellIdentifier = "scheduleDetail"
    let calendarDateFormat = "yyyy MM dd"
    let numberOfRowsInCalendar = 6
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    
    var schedulesGroupByDate: Dictionary<Date, [Schedule]> = Dictionary()
    let persistence: SchedulePersistence = SchedulePersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewNibs()
        select(date: Date())
    }
    
    func select(date: Date) {
        self.getSchedules(date)
        calendarView.scrollToDate(date, triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.updateViewTitle(from: self.calendarView.visibleDates())
            self.adjustCalendarViewHeight()
            self.calendarView.selectDates([date])
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
    
    private func getSchedules(_ startDate: Date) {
        schedulesGroupByDate = persistence.load(from: startDate).group{$0.dayOfTheEvent}
    }
    
    private func updateViewTitle(from visibleDates: DateSegmentInfo) {
        let startDate = (calendarView.visibleDates().monthDates.first?.date)!
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthString = DateFormatter().monthSymbols[month-1]
        visibleDates.monthDates.first.map{Calendar.current.component(.year, from: $0.date)}.map { navigationItem.title = "\($0) \(monthString)"}
    }
}
