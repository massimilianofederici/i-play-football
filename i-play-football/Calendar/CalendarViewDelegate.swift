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
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let initialSelection = visibleDates.monthDates.first.map {$0.date.isThisMonth() ? Date() : $0.date}
        select(date: initialSelection!)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        tableView.reloadData()
        tableView.contentOffset = CGPoint()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
    private func configureCell(view: JTAppleCell?, cellState: CellState) {
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
        myCustomCell.eventView.isHidden = schedulesGroupByDate[cellState.date]?.count ?? 0 == 0;
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
