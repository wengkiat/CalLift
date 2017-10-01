//
//  BluetoothScannerDelegate.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import Foundation

protocol BluetoothScannerDelegate: class {

    func readyToScan()
    func foundUUID(_: String)

}
