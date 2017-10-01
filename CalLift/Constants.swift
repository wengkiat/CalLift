//
//  Constants.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import CoreBluetooth
import Foundation

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
    }

    struct Bluetooth {
        static let uuid = CBUUID(string: "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFF0")
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

}
