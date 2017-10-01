//
//  LiftCalendar.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import EventKit
import UIKit

class LiftCalendar {

    var calendars: [EKCalendar]
    var selected: EKCalendar?
    var selectedEvent: EKEvent?
    private var eventStore = EKEventStore()

    init() {
        self.calendars = []
    }

    func loadCalendars() {
        self.calendars = EKEventStore().calendars(for: .event)
    }

    func getNextEvent() -> EKEvent? {
        if getUpcomingEvents().count == 0 {
            return createInitialEvent()
        }
        return getUpcomingEvents().first
    }

    func getUpcomingEvents() -> [EKEvent] {
        let startDate = Date()
        let endDate = Calendar.current.date(
            byAdding: .month, value: Constants.LiftCalendar.endMonths, to: startDate)!
        return getEvents(from: startDate, to: endDate)
    }

    func getEvents(from startDate: Date, to endDate: Date) -> [EKEvent] {
        if selected == nil {
            self.calendars = EKEventStore().calendars(for: .event).filter { $0.title == Constants.LiftCalendar.defaultCalName }
        }
        let eventsPredicate = eventStore.predicateForEvents(
            withStart: startDate, end: endDate, calendars: calendars)
        return eventStore.events(matching: eventsPredicate).sorted { (e1, e2) -> Bool in
            return e1.startDate.compare(e2.startDate) == ComparisonResult.orderedAscending
        }
    }
    
    func upsertCalendarAndEvent() -> EKEvent? {
        let calendarName = Constants.LiftCalendar.defaultCalName
        self.calendars = EKEventStore().calendars(for: .event).filter { $0.title == calendarName }
        if self.calendars.count == 0 {
            self.selected = insertCalendar(calendarName)
            let firstEvent = createInitialEvent()
            self.selectedEvent = firstEvent
            return firstEvent
        } else {
            self.selected = self.calendars.first
            let nextEvent = getNextEvent()
            self.selectedEvent = nextEvent
            return nextEvent
        }
    }

    func insertCalendar(_ name: String) -> EKCalendar? {
        let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        newCalendar.title = name
        newCalendar.source = self.eventStore.defaultCalendarForNewEvents?.source
        do {
            try self.eventStore.saveCalendar(newCalendar, commit: true)
            return newCalendar
        } catch {
            print("Save failed!")
            return nil
        }
    }

    func createInitialEvent() -> EKEvent? {
        
        // Use Event Store to create a new calendar instance
        if self.selected == nil {
            return nil
        }
        let newEvent = EKEvent(eventStore: eventStore)
        
        newEvent.calendar = selected!
        let now = Date()
        let startDate = now.addingTimeInterval(10.0 * 60.0)
        let endDate = startDate.addingTimeInterval(20 * 60.0)
        newEvent.startDate = startDate
        newEvent.endDate = endDate
        newEvent.title = "Project Meeting"
        newEvent.location = Constants.Mock.Destination.floor
        do {
            try eventStore.save(newEvent, span: .thisEvent, commit: true)
        } catch {
            NSLog("Event creation failed")
            return nil
        }
        return newEvent
    }

}
