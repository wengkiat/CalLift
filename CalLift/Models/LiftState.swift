//
//  LiftState.swift
//  CalLift
//
//  Created by Edmund Mok on 10/1/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import Foundation

struct LiftState {

    let movingDirection: String
    let movingState: String
    let lastUpdated: Date
    let level: Int
    let doorState: String
    let name: String

    init(json: [[String: Any]]) {
        var attrsDict = [String: Any]()
        for dict in json {
            let data = dict["data"] as! NSArray
            for obj in data {
                let nameValDict = obj as! [String: Any]
                let name = nameValDict["name"] as! String
                let val = nameValDict["value"]!
                attrsDict[name] = val
            }
        }

        self.movingDirection = attrsDict["movingDirection"] as! String
        self.movingState = attrsDict["movingState"] as! String
        self.lastUpdated = Date(timeIntervalSince1970: TimeInterval(attrsDict["lastUpdated"] as! Int))
        self.level = attrsDict["level"] as! Int
        self.doorState = attrsDict["state"] as! String
        self.name = attrsDict["name"] as! String
    }

}
