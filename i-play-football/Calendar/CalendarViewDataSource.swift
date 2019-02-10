//
//  CalendarViewDataSource.swift
//  i-play-football
//
//  Created by Massimiliano Federici on 03/02/2019.
//  Copyright © 2019 Massimiliano Federici. All rights reserved.
//

import Foundation
import JTAppleCalendar

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        var startDate = DateComponents()
        startDate.year = 2017
        startDate.month = 1
        startDate.day = 1
        var endDate = DateComponents()
        endDate.year = 2030
        endDate.month = 12
        endDate.day = 31
        let parameters = ConfigurationParameters(startDate: Calendar.current.date(from: startDate)!,
                                                 endDate: Calendar.current.date(from: endDate)!,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 hasStrictBoundaries: true)
        return parameters
    }
}
