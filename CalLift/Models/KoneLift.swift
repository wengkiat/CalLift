//
//  KoneLift.swift
//  CalLift
//
//  Created by Edmund Mok on 10/1/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import Foundation

struct KoneLift {

    let id: String
    let KEN: String
    let name: String
    let type: String
    let monitoringEnabled: Bool

    init(dict: NSDictionary) {
        self.id = dict.value(forKey: "id") as! String
        self.KEN = dict.value(forKey: "KEN") as! String
        self.name = dict.value(forKey: "name") as! String
        self.type = dict.value(forKey: "type") as! String
        self.monitoringEnabled = dict.value(forKey: "monitoringEnabled") as! Bool
    }

}
