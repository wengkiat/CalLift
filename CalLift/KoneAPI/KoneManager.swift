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

    var floorLevelDict = [Int: Int]()
    var levelFloorDict = [Int: Int]()
    
    func populateFloorData() {


    }

    func bookLift(from startFloor: Int, to endFloor: Int, completion: @escaping (_ message: String) -> Void) {
        let postJson =
        """
            {
              "template": {
                "data": [
                  {"name":"sourceAreaId", "value": "area:\(Constants.KoneAPI.buildingId):\(floorLevelDict[startFloor]!)"},
                  {"name":"destinationAreaId", "value": "area:\(Constants.KoneAPI.buildingId):\(floorLevelDict[endFloor]!)"}
                ]
              }
            }
        """
        let postData = NSData(data: postJson.data(using: String.Encoding.utf8)!) as Data

        let apiEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/call"
        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = Constants.KoneAPI.postMethod
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .api)
        request.httpBody = postData
        submitTask(with: request) { (response, data) in
            // Get the call id from this data.
            print(response)
        }
    }

    private func submitTask(with request: URLRequest, completionHandler: @escaping (URLResponse, Data) -> Void) {
        session.dataTask(with: request) {(data, res, err) in
            DispatchQueue.main.async {
                guard err != nil else {
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
                completionHandler(response, data!)
            }
        }.resume()
    }

    func getAssignedLift(callId: String, completion: @escaping(_ message: String) -> Void) {
        let urlEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/call/\(callId)"
        var request = URLRequest(url: URL(string: urlEndpoint)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .javascript)

        session.dataTask(with: request,  completionHandler: {(data, res, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                guard let response = res as? HTTPURLResponse else {
                    NSLog("No response!")
                    return
                }
                guard Constants.isDemo else {
                    NSLog("Parse JSON \(response)")
                    return
                }
                // Parse data to get lift floor and door state
                guard let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else { return }
                print(json)
                guard let data = json["data"] as? [[String : Any]] else { return }
                print(data)
                completion("1")
            }
        }).resume()
    }

    func getLevels(liftId: String, completion: @escaping(_ message: String) -> Void) {
        let urlEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/lift/\(liftId)/liftlevel"
        var request = URLRequest(url: URL(string: urlEndpoint)!)
        request.httpMethod = Constants.KoneAPI.getMethod
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .api)

        submitTask(with: request) { (_, data) in
            // Parse data to get lift floor and door state
            guard let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
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

    func getDestinations(buildingId: Int=Constants.KoneAPI.buildingId,
                         completion: @escaping (_ destinations: [String: Any]) -> Void) {
        let apiEndpoint = "https://api.kone.com/api/building/\(buildingId)"
        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = Constants.KoneAPI.getMethod
        request.allHTTPHeaderFields = Constants.KoneAPI.getHeaders(contentType: .collection, acceptType: .api)

        submitTask(with: request) { (_, data) in
            guard let dict = data.toDictionary() else {
                NSLog("No data")
                return
            }
            completion(dict)
        }
    }
}
