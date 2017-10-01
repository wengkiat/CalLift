//
//  Constants.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import CoreBluetooth
import UIKit

typealias JSONObject = [String: Any]

enum KoneContentType: String {
    case collection = "application/vnd.collection+json"
    case api = "application/vnd.api+json"
    case json = "application/json"
}

enum KoneAcceptType: String {
    case collection = "application/vnd.collection+json"
    case api = "application/vnd.api+json"
    case javascript = "application/javascript"
}

struct Constants {

    static let isDemo = true

    struct LiftCalendar {
        static let endMonths = 1
        static let floorString = "floor "
        static let defaultCalName = "CalLIFT"
    }

    struct Bluetooth {
        static let uuid = CBUUID(string: "AFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFA0")  // A
        static let uuidKey = "kCBAdvDataServiceUUIDs"
    }

    struct KoneAPI {
        static let clientId = "711eff77-74cc-448d-a4b3-42f30e010502"
        static let secretKey = "A4hY4oN2qP5yL7uN0uS5hV6kK3vD0tE0nS8uD5qL7wC0uQ3iR2"
        static let buildingId = 9990000508
        static let getMethod = "GET"
        static let postMethod = "POST"
        static func getHeaders(contentType: KoneContentType, acceptType: KoneAcceptType) -> [String: String] {
            return [
                "x-ibm-client-id": Constants.KoneAPI.clientId,
                "x-ibm-client-secret": Constants.KoneAPI.secretKey,
                "content-type": contentType.rawValue,
                "accept": acceptType.rawValue
            ]
        }
    }
    
    struct Mock {
        struct Source {
            static let floor = "Floor K1"
            static let area = "Lift Lobby B1A"
        }
        struct Destination {
            static let index = 10
            static let floor = "Floor 10"
            static let area = "PnP Conference Room Lift"
        }
    }
    
    struct Colors {
        static let flatRed = UIColor(red: 231/255.0, green: 76/255.0, blue: 60/255.0, alpha: 1.0)
        static let flatYellow = UIColor(red: 241/255.0, green: 196/255.0, blue: 15/255.0, alpha: 1.0)
        static let flatOrange = UIColor(red: 230/255.0, green: 126/255.0, blue: 34/255.0, alpha: 1.0)
        static let flatGray = UIColor(red: 149/255.0, green: 165/255.0, blue: 166/255.0, alpha: 1.0)
        static let flatDarkGreen = UIColor(red: 39/255.0, green: 174/255.0, blue: 96/255.0, alpha: 1.0)
        static let flatGreen = UIColor(red: 46/255.0, green: 204/255.0, blue: 113/255.0, alpha: 1.0)
    }

}
