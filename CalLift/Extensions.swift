//
//  Extensions.swift
//  CalLift
//
//  Created by Leon Mak on 1/10/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import UIKit

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

extension UIView {
    func setCornerRadius(radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    func setShadow() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = CGSize(width: 6.0, height: 6.0)
    }
    
    func setBlur(style: UIBlurEffectStyle=UIBlurEffectStyle.light, corner: CGFloat=0.0,
                 alpha: CGFloat=1.0, replaceViewAlpha: Bool=false, id: String?=nil) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = alpha
        if corner > 0 {
            blurEffectView.layer.cornerRadius = corner
            blurEffectView.clipsToBounds = true
        }
        if replaceViewAlpha {
            self.backgroundColor = UIColor.clear
        }
        if let accessibilityId = id {
            blurEffectView.accessibilityIdentifier = accessibilityId
        }
        self.insertSubview(blurEffectView, at: 0)
    }
}

