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
    let session = URLSession.shared

    func bookLift(sourceAreaId: String, destinationAreaId: String, completion: @escaping (_ message: String) -> Void) {
        let headers = [
            "x-ibm-client-id": Constants.KoneAPI.clientId,
            "x-ibm-client-secret": Constants.KoneAPI.secretKey,
            "content-type": "application/vnd.api+json",
            "accept": "application/vnd.api+json"
        ]
        let postJson = """
            {
              "template": {
                "data": [
                  {"name":"sourceAreaId", "value": "area:\(sourceAreaId):1000"},
                  {"name":"destinationAreaId", "value": "area:\(destinationAreaId):2000"}
                ]
              }
            }
        """
        let postData = NSData(data: postJson.data(using: String.Encoding.utf8)!) as Data

        let apiEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/call"
        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        let dataTask = session.dataTask(with: request,  completionHandler: {(data, res, err) in
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
                let responseString = "Success"
                completion(responseString)
            }
        })
        dataTask.resume()
    }
    
    func getDestinations(buildingId: Int=Constants.KoneAPI.buildingId,
                         completion: @escaping (_ destinations: [String: Any]) -> Void) {
        let headers = [
            "x-ibm-client-id": Constants.KoneAPI.clientId,
            "x-ibm-client-secret": Constants.KoneAPI.secretKey,
            "accept": "application/vnd.api+json"
        ]
        let apiEndpoint = "https://api.kone.com/api/building/\(buildingId)"
        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil else {
                NSLog(error!.localizedDescription)
                return
            }
            guard data != nil, let dict = data!.toDictionary() else {
                NSLog("No data")
                return
            }
            completion(dict)
        })
        dataTask.resume()
    }
}
