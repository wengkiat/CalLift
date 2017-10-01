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
    var peripheral: CBPeripheral!
    var mainCharacteristics: CBCharacteristic!
    weak var delegate: BluetoothScannerDelegate?

    let BLEService = "DFB0"
    let BLECharacteristic = "DFB1"

    override init() {
        self.manager = CBCentralManager(delegate: self, queue: nil)
        self.manager.delegate = self
    }

    func startScanning() {
        self.manager.scanForPeripherals(withServices: [CBUUID(string: self.BLEService)], options: nil)
    }

    func stopScanning() {
        self.manager.stopScan()
    }

}

// MARK: CBCentralManagerDelegate
extension BluetoothScanner: CBCentralManagerDelegate {

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.delegate?.nearbyBluetoothDevicesUpdated()
        print(peripheral)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        return
    }

}

// MARK: CBPeripheralDelegate
extension BluetoothScanner: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print(peripheral)
        return
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(peripheral)
        return
    }
}
