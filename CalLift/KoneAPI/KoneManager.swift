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
    
    func bookLift() {
        let headers = [
            "x-ibm-client-id": Constants.KoneAPI.clientId,
            "x-ibm-client-secret": Constants.KoneAPI.secretKey,
            "content-type": "application/vnd.api+json",
            "accept": "application/vnd.api+json"
        ]
        
        let postData = NSData(data: "{\"template\":{\"data\":[{\"value\":\"1234\",\"name\":\"id\"}]}}".data(using: String.Encoding.utf8)!) as Data

        let urlEndpoint = "https://api.kone.com/api/building/\(Constants.KoneAPI.buildingId)/call"
        var request = URLRequest(url: URL(string: urlEndpoint)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request,  completionHandler:  {(data, res, err) in
            if err != nil {
                print(err.debugDescription)
            } else {
                guard let response = res as? HTTPURLResponse else {
                    print("No response!")
                    return
                }
                print(response)
            }
        })
        dataTask.resume()
    }
}
