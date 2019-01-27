import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    
    lazy var schedulesGroupByDate: Dictionary<Date, [Schedule]> = { [unowned self] in
        return loadSchedules()
        }()
    
    private func loadSchedules() -> Dictionary<Date, [Schedule]> {
        var data:[Schedule] = []
        let today: Date = Calendar.current.startOfDay(for: Date())
        data.append(Schedule(fromStartDate: today))
        let date = Calendar.current.date(byAdding: .day, value: 5, to: today)
        data.append(Schedule(fromStartDate: date!))
        return data.group{$0.dayOfTheEvent}
    }
    
    let formatter = DateFormatter()
    let dateFormatterString = "yyyy MM dd"
    let numOfRowsInCalendar = 6
    let calendarCellIdentifier = "CalendarCell"
    let scheduleCellIdentifier = "detail"
    
    var iii: Date?
    
    var numOfRowIsSix: Bool {
        get {
            return calendarView.visibleDates().outdates.count < 7
        }
    }
    
    var currentMonthSymbol: String {
        get {
            let startDate = (calendarView.visibleDates().monthDates.first?.date)!
            let month = Calendar.current.dateComponents([.month], from: startDate).month!
            let monthString = DateFormatter().monthSymbols[month-1]
            return monthString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewNibs()
        showToday(animate: false)
        
        let gesturer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        calendarView.addGestureRecognizer(gesturer)
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer) {
        let point = gesture.location(in: calendarView)
        guard let cellStatus = calendarView.cellStatus(at: point) else {
            return
        }
        
        if calendarView.selectedDates.first != cellStatus.date {
            calendarView.deselectAllDates()
            calendarView.selectDates([cellStatus.date])
        }
    }
    
    func setupViewNibs() {
        let myNib = UINib(nibName: calendarCellIdentifier, bundle: Bundle.main)
        calendarView.register(myNib, forCellWithReuseIdentifier: calendarCellIdentifier)
        
        
        let myNib2 = UINib(nibName: "ScheduleTableViewCell", bundle: Bundle.main)
        tableView.register(myNib2, forCellReuseIdentifier: scheduleCellIdentifier)
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        
        let year = Calendar.current.component(.year, from: startDate)
        navigationItem.title = "\(year) \(currentMonthSymbol)"
    }
}

extension CalendarViewController {
    func select(onVisibleDates visibleDates: DateSegmentInfo) {
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
    func showTodayWithAnimate() {
        showToday(animate: true)
    }
    
    func showToday(animate:Bool) {
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: animate, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            //            self.getSchedule()
            self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            }
            
            self.adjustCalendarViewHeight()
            self.calendarView.selectDates([Date()])
        }
    }
}

extension CalendarViewController {
    func adjustCalendarViewHeight() {
        adjustCalendarViewHeight(higher: self.numOfRowIsSix)
    }
    
    func adjustCalendarViewHeight(higher: Bool) {
        separatorViewTopConstraint.constant = higher ? 0 : -calendarView.frame.height / CGFloat(numOfRowsInCalendar)
    }
}

extension CalendarViewController {
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? CalendarCell else { return }
        
        myCustomCell.dayLabel.text = cellState.text
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        
        myCustomCell.isHidden = cellHidden
        myCustomCell.selectedView.backgroundColor = UIColor.black
        
        if Calendar.current.isDateInToday(cellState.date) {
            myCustomCell.selectedView.backgroundColor = UIColor.red
        }
        
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
        if schedulesGroupByDate[cellState.date]?.count ?? 0 > 0 {
            myCustomCell.eventView.isHidden = false
        } else{
            myCustomCell.eventView.isHidden = true
        }
    }
    
    func handleCellSelection(view: CalendarCell, cellState: CellState) {
        view.selectedView.isHidden = !cellState.isSelected
    }
    
    func handleCellTextColor(view: CalendarCell, cellState: CellState) {
        if cellState.isSelected {
            view.dayLabel.textColor = UIColor.white
        }
        else {
            view.dayLabel.textColor = UIColor.black
            if cellState.day == .sunday || cellState.day == .saturday {
                view.dayLabel.textColor = UIColor.gray
            }
        }
        
        if Calendar.current.isDateInToday(cellState.date) {
            if cellState.isSelected {
                view.dayLabel.textColor = UIColor.white
            }
            else {
                view.dayLabel.textColor = UIColor.red
            }
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = dateFormatterString
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2030 02 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: numOfRowsInCalendar,
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
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calendarCellIdentifier, for: indexPath) as! CalendarCell
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calendarCellIdentifier, for: indexPath) as! CalendarCell
        configureCell(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        if visibleDates.monthDates.first?.date == iii {
            return
        }
        
        iii = visibleDates.monthDates.first?.date
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: scheduleCellIdentifier, for: indexPath) as! ScheduleTableViewCell
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
