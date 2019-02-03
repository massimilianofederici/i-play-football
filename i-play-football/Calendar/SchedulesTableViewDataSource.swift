//
//  SchedulesDataSource.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 03/02/2019.
//  Copyright © 2019 Massimiliano Federici. All rights reserved.
//

import Foundation
import UIKit

extension CalendarViewController: UITableViewDataSource {
    
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