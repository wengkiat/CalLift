//
//  BluetoothScanner.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import CoreBluetooth
import Foundation

class BluetoothScanner: NSObject {

    var manager: CBCentralManager!
    weak var delegate: BluetoothScannerDelegate?

    override init() {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
        self.manager.delegate = self
    }

    func startScanning() {
        self.manager.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: true
            ])
    }

    func stopScanning() {
        self.manager.stopScan()
    }

}

// MARK: CBCentralManagerDelegate
extension BluetoothScanner: CBCentralManagerDelegate {

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let uuids = advertisementData[Constants.Bluetooth.uuidKey] as? NSMutableArray else {
            return
        }
        guard let uuid = uuids.firstObject as? CBUUID else { return }
        guard uuid == Constants.Bluetooth.uuid else { return }
        self.delegate?.nearbyBluetoothDevicesUpdated()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.delegate?.readyToScan()
    }

}
