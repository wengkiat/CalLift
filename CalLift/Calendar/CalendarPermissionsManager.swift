//
//  CalendarPermissionsManager.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import EventKit
import Foundation

/**
 Handles all logic in getting permissions for calendar access.
 */
class CalendarPermissionsManager {

    static let sharedInstance = CalendarPermissionsManager()

    var status: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }

    private init() { }

    // Keep asking for permission until we get it
    func getPermissions() {
        switch self.status {
        case .authorized: return
        default: self.requestAccess()
        }
    }

    private func requestAccess() {
        EKEventStore().requestAccess(to: .event) { (accessGranted, error) in
            guard !accessGranted else { return }
            DispatchQueue.main.async {
                self.getPermissions()
            }
        }
    }

}
