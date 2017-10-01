//
//  Constants.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import CoreBluetooth
import Foundation

struct Constants {

    struct LiftCalendar {
        static let endMonths = 1
    }

    struct Bluetooth {
        static let uuid = CBUUID(string: "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFF0")
        static let uuidKey = "kCBAdvDataServiceUUIDs"
    }

}
