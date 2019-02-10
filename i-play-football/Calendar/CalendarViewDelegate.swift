//
//  CalendarViewDelegate.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 03/02/2019.
//  Copyright © 2019 Massimiliano Federici. All rights reserved.
//

import Foundation
import JTAppleCalendar

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calendarCellIdentifier,
                                                       for: indexPath) as! CalendarCell
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calendarCellIdentifier,
                                                       for: indexPath) as! CalendarCell
        configureCell(view: cell, cellState: cellState)
        return cell
    }
    
    // invoked on scrolling
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let firstDayOfMonth: Date = visibleDates.monthDates.first!.date
        let initialSelection = firstDayOfMonth.isThisMonth() ? Date() : firstDayOfMonth
        prefetchSchedules(from: initialSelection)
        calendar.reloadData{ self.select(date: initialSelection) }
    }
    
    // invoked on date selection
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        tableView.reloadData()
        tableView.contentOffset = CGPoint()
    }
    
    // invoked on date deselection
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    private func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? CalendarCell else { return }
        
        // hide if outiside current month
        cell.isHidden = !(cellState.dateBelongsTo == .thisMonth)
        
        cell.dayLabel.text = cellState.text
        cell.dayLabel.textColor = textColor(for: cellState)
        
        cell.selectedView.backgroundColor = UIColor.black
        if cellState.date.isToday() {
            cell.selectedView.backgroundColor = UIColor.red
        }
        cell.selectedView.isHidden = !cellState.isSelected
        
        cell.eventView.isHidden = !schedules.hasEvent(for: cellState.date)
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
