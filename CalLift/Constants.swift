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
    
    static let isDemo = true

    struct LiftCalendar {
        static let endMonths = 1
    }

    struct Bluetooth {
        static let uuid = CBUUID(string: "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFF0")
        static let uuidKey = "kCBAdvDataServiceUUIDs"
    }

    struct KoneAPI {
        static let clientId = "711eff77-74cc-448d-a4b3-42f30e010502"
        static let secretKey = "A4hY4oN2qP5yL7uN0uS5hV6kK3vD0tE0nS8uD5qL7wC0uQ3iR2"
        static let buildingId = 9990000508
    }

}
