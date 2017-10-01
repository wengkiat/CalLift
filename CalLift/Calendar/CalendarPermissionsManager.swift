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

    var status: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }

    // Keep asking for permission until we get it
    func getPermissions() {
        switch self.status {
        case .authorized: return
        default: self.requestAccess()
        }
    }

    private func requestAccess() {
        EKEventStore().requestAccess(to: .event) { (accessGranted, error) in
            DispatchQueue.main.async {
                self.getPermissions()
            }
        }
    }

}
