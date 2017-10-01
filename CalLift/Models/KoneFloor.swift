//
//  KoneFloor.swift
//  CalLift
//
//  Created by Edmund Mok on 10/1/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import Foundation

struct KoneFloor {
    let id: String
    let index: Int
    let name: String
    let typicalLevel: Int
    let areaId: String

    init(dict: NSDictionary, areaMap: [String: String]) {
        self.id = dict.value(forKey: "id") as! String
        self.index = dict.value(forKey: "index") as! Int
        self.name = dict.value(forKey: "name") as! String
        self.typicalLevel = dict.value(forKey: "typicalLevel") as! Int
        self.areaId = "" // areaMap[id]
    }
}
