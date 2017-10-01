//
//  LiftEventParser.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import EventKit
import Foundation

struct LiftEvent {
    let event: EKEvent
    let destinationFloor: Int
}

class LiftEventParser {

    let event: EKEvent

    init(event: EKEvent) {
        self.event = event
    }

    func parse() -> LiftEvent {
        // Look for destination floor in title or description
        if let pos = event.title.lowercased().range(of: Constants.LiftCalendar.floorString) {
            return LiftEvent(event: event, destinationFloor: extractFloor(pos: pos, str: event.title.lowercased()))
        }

        if let pos = event.description.lowercased().range(of: Constants.LiftCalendar.floorString) {
            return LiftEvent(event: event, destinationFloor: extractFloor(pos: pos, str: event.title.lowercased()))
        }

        // Otherwise assume it is in another building
        return LiftEvent(event: event, destinationFloor: 1)
    }

    private func extractFloor(pos: Range<String.Index>, str: String) -> Int {
        let start = pos.lowerBound.encodedOffset + Constants.LiftCalendar.floorString.count
        var currFloor = ""
        for i in start..<str.count {
            let char = str[str.index(str.startIndex, offsetBy: i)]
            guard Int(currFloor + String(char)) != nil else { return Int(currFloor)! }
            currFloor = currFloor + String(char)
        }
        return 1
    }
}
