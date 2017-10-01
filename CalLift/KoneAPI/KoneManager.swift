//
//  KoneManager.swift
//  CalLift
//
//  Created by Leon Mak on 30/9/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import Foundation

class KoneManager {
    private init() {}
    static let instance = KoneManager()
    private let session = URLSession.shared

    var floors = [KoneFloor]()

    func populateFloorData() {
        guard floors.isEmpty else { return }
        getFloors { self.floors = $0 }
    }

    func getFloor(at level: Int) -> KoneFloor? {
        return floors.first { $0.typicalLevel == level }
    }

    func bookLift(from startFloor: Int, to endFloor: Int, completion: @escaping (_ message: String) -> Void) {
        populateFloorData()
        guard let startLevel = getFloor(at: startFloor)?.typicalLevel,
            let endLevel = getFloor(at: endFloor)?.typicalLevel else {
                return
        }

        let postJson =
        """
            {
              "template": {
                "data": [
                  {"name":"sourceAreaId", "value": "area:\(Constants.KoneAPI.buildingId):\(startLevel)"},
                  {"name":"destinationAreaId", "value": "area:\(Constants.KoneAPI.buildingId):\(endLevel)"}
                ]
              }
            }
        """
        let postData = NSData(data: postJson.data(using: .utf8)!) as Data
        let apiEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/call"
        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = Constants.KoneAPI.postMethod
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .api)
        request.httpBody = postData
        submitTask(with: request) { (response, _) in
            print("CALLED!")
            // Get the call id from this data.
            print(response)
            guard let transactionID = response.value(forKey: "X-Global-Transaction-ID") as? String else {
                return
            }
            print(transactionID)
        }
    }

    func getAssignedLift(callId: String, completion: @escaping(_ message: String) -> Void) {
        let urlEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/call/\(callId)"
        var request = URLRequest(url: URL(string: urlEndpoint)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .javascript)

        submitTask(with: request) { (_, data) in
            // Parse data to get lift floor and door state
            guard let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
            print(json)
            guard let data = json["data"] as? [[String : Any]] else { return }
            print(data)
            completion("1")
        }
    }

    func getLiftState(liftId: String, completion: @escaping (_ message: String) -> Void) {
        let urlEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/lift/\(liftId)/liftstate"
        var request = URLRequest(url: URL(string: urlEndpoint)!)
        request.httpMethod = Constants.KoneAPI.getMethod
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .collection)

        submitTask(with: request) { (_, data) in
            // Parse data to get lift floor and door state
            guard let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
            guard let collection = json["collection"] as? [String : Any] else { return }
            guard let items = collection["items"] as? [[String: Any]] else { return }
            print(items)
            completion("1")
        }
    }

    func getFloors(completionHandler: @escaping (_ floors: [KoneFloor]) -> Void) {
        let apiEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)"
        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = Constants.KoneAPI.getMethod
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .api)

        submitTask(with: request) { (_, data) in
            guard let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
            guard let data = json["data"] as? NSArray else { return }
            let floors: [KoneFloor] = data.map {
                guard let dict = $0 as? NSDictionary else { fatalError() }
                guard let attr = dict.value(forKey: "attributes") as? NSDictionary else { fatalError() }
                return KoneFloor(dict: attr)
            }
            completionHandler(floors)
        }
    }

    func getLevels(liftId: String, completion: @escaping(_ message: String) -> Void) {
        let urlEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/lift/\(liftId)/liftlevel"
        var request = URLRequest(url: URL(string: urlEndpoint)!)
        request.httpMethod = Constants.KoneAPI.getMethod
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .collection)

        submitTask(with: request) { (_, data) in
            // Parse data to get lift floor and door state
            guard let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
            print(json)
            guard let data = json["data"] as? [[String : Any]] else { return }
            print(data)
            completion("1")
        }
    }

    private func submitTask(with request: URLRequest, completionHandler: @escaping (URLResponse, Data) -> Void) {
        session.dataTask(with: request) {(data, res, err) in
            DispatchQueue.main.async {
                guard err == nil else {
                    print(err.debugDescription)
                    return
                }
                guard let response = res as? HTTPURLResponse else {
                    NSLog("No response!")
                    return
                }
                guard Constants.isDemo else {
                    NSLog("Parse JSON \(response)")
                    return
                }
                print("response: \(response)")
                print("data: \(data)")
                completionHandler(response, data!)
            }
        }.resume()
    }
}
