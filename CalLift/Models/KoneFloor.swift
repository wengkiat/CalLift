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

    init(dict: NSDictionary) {
        self.id = dict.value(forKey: "id") as! String
        self.index = dict.value(forKey: "index") as! Int
        self.name = dict.value(forKey: "name") as! String
        self.typicalLevel = dict.value(forKey: "index") as! Int
    }
}
