//
//  Extensions.swift
//  CalLift
//
//  Created by Leon Mak on 1/10/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import Foundation

extension Data {
    func toDictionary() -> [String: Any]? {
        
        guard let responseString = String(data: self, encoding: String.Encoding.utf8),
            let data = responseString.data(using: .utf8) else {
                NSLog("JSON Formating Invalid")
                return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            NSLog(error.localizedDescription)
        }
        return nil
    }
}

extension Dictionary where Key == String, Value == Any {
    func getItems() -> [Dictionary] {
        var result: [[String: Any]] = []
        if let items = self["data"] as? [[String: Any]] {
            result = items.map { item in
                return item["attributes"] as! [String: Any]
            }
        }
        return result
    }
}

