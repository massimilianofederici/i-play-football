import JTAppleCalendar

#warning("fix indicator for scheduled events")
class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    
    struct Constants {
        static let calendarCellIdentifier = "calendarCell"
        static let scheduleCellIdentifier = "scheduleDetail"
        static let calendarDateFormat = "yyy MM dd"
        static let numberOfRowsInCalendar = 6
    }
    
    var schedulesGroupByDate: Dictionary<Date, [Schedule]> = Dictionary()
    let formatter = DateFormatter()
    let persistence: SchedulePersistence = SchedulePersistence()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewNibs()
        showToday()
    }
    
    private func setupViewNibs() {
        let calendarCellView = UINib(nibName: "CalendarCell", bundle: Bundle.main)
        calendarView.register(calendarCellView, forCellWithReuseIdentifier: Constants.calendarCellIdentifier)
        let tableCellView = UINib(nibName: "ScheduleTableViewCell", bundle: Bundle.main)
        tableView.register(tableCellView, forCellReuseIdentifier: Constants.scheduleCellIdentifier)
    }
    
    func adjustCalendarViewHeight() {
        let higher = calendarView.visibleDates().outdates.count < 7
        separatorViewTopConstraint.constant = higher ? 0 : -calendarView.frame.height / CGFloat(Constants.numberOfRowsInCalendar)
    }
    
    private func getSchedules() {
        if let startDate = calendarView.visibleDates().monthDates.first?.date  {
            schedulesGroupByDate = persistence.load(from: startDate)
        }
    }
    
    private func showToday() {
        let today = Date()
        calendarView.scrollToDate(today, triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.getSchedules()
            self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
                self.updateViewTitle(from: visibleDates)
            }
            self.adjustCalendarViewHeight()
            self.calendarView.selectDates([today])
        }
    }
    
    private func updateViewTitle(from visibleDates: DateSegmentInfo) {
        let startDate = (calendarView.visibleDates().monthDates.first?.date)!
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthString = DateFormatter().monthSymbols[month-1]
        visibleDates.monthDates.first.map{Calendar.current.component(.year, from: $0.date)}.map { navigationItem.title = "\($0) \(monthString)"}
    }
}

extension CalendarViewController {
    func select(onVisibleDates visibleDates: DateSegmentInfo) {
        #warning("ugly")
        guard let firstDateInMonth = visibleDates.monthDates.first?.date else
        { return }
        
        if firstDateInMonth.isThisMonth() {
            calendarView.selectDates([Date()])
        } else {
            calendarView.selectDates([firstDateInMonth])
        }
    }
}

extension CalendarViewController {
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CalendarCell else { return }
        
        // hide if outiside current month
        myCustomCell.isHidden = !(cellState.dateBelongsTo == .thisMonth)
        
        myCustomCell.dayLabel.text = cellState.text
        myCustomCell.dayLabel.textColor = textColor(for: cellState)
        
        myCustomCell.selectedView.isHidden = !cellState.isSelected
        myCustomCell.selectedView.backgroundColor = UIColor.black
        if cellState.date.isToday() {
            myCustomCell.selectedView.backgroundColor = UIColor.red
        }
        
        // display the indicator if there's at least one event
        if schedulesGroupByDate[cellState.date]?.count ?? 0 > 0 {
            myCustomCell.eventView.isHidden = false
        } else {
            myCustomCell.eventView.isHidden = true
        }
    }
    
    private func textColor(for cellState: CellState) -> UIColor {
        if cellState.isSelected {
            return .white
        }
        if cellState.date.isToday() {
            return .red
        }
        if cellState.day == .sunday || cellState.day == .saturday {
            return .gray
        }
        return .black
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = Constants.calendarDateFormat
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2030 02 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: Constants.numberOfRowsInCalendar,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday,
                                                 hasStrictBoundaries: true)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        #warning("Extract to commond method")
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.calendarCellIdentifier,
                                                       for: indexPath) as! CalendarCell
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: Constants.calendarCellIdentifier,
                                                       for: indexPath) as! CalendarCell
        configureCell(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        getSchedules()
        updateViewTitle(from: visibleDates)
        select(onVisibleDates: visibleDates)
        
        view.layoutIfNeeded()
        
        adjustCalendarViewHeight()
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        tableView.reloadData()
        tableView.contentOffset = CGPoint()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
}

extension CalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.scheduleCellIdentifier, for: indexPath) as! ScheduleTableViewCell
        cell.selectionStyle = .none
        calendarView.selectedDates.first.map{d in
            cell.schedule = schedulesGroupByDate[d]?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = calendarView.selectedDates.first.map{schedulesGroupByDate[$0]?.count ?? 0} ?? 0
        return count
    }
}

extension CalendarViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
