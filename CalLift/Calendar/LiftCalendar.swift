//
//  LiftCalendar.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import EventKit
import Foundation

class LiftCalendar {

    var calendars: [EKCalendar]

    init() {
        self.calendars = []
    }

    func loadCalendars() {
        self.calendars = EKEventStore().calendars(for: .event)
    }

    func getNextEvent() -> EKEvent? {
        return getUpcomingEvents().first
    }

    func getUpcomingEvents() -> [EKEvent] {
        let startDate = Date()
        let endDate = Calendar.current.date(
            byAdding: .month, value: Constants.LiftCalendar.endMonths, to: startDate)!
        return getEvents(from: startDate, to: endDate)
    }

    func getEvents(from startDate: Date, to endDate: Date) -> [EKEvent] {
        let eventStore = EKEventStore()
        let eventsPredicate = eventStore.predicateForEvents(
            withStart: startDate, end: endDate, calendars: calendars)
        return eventStore.events(matching: eventsPredicate).sorted { (e1, e2) -> Bool in
            return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
        }
    }

}
