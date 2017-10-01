//
//  ScanState.swift
//  CalLift
//
//  Created by Leon Mak on 1/10/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import Foundation

enum ScanState {
    case stopped, started, found
    
    func getLoadingLabel() -> String {
        switch self {
        case .stopped: return "Current floor unknown"
        case .started: return ""
        case .found: return ""
        }
    }
}
