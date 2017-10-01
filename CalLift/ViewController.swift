//
//  ViewController.swift
//  CalLift
//
//  Created by Edmund Mok on 9/30/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let scanner = BluetoothScanner()
    let calendar = LiftCalendar()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        CalendarPermissionsManager.sharedInstance.getPermissions()
        scanner.delegate = self
        calendar.loadCalendars()
        print(calendar.getUpcomingEvents())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: BluetoothScannerDelegate
extension ViewController: BluetoothScannerDelegate {

    func readyToScan() {
        scanner.startScanning()
    }

    func nearbyBluetoothDevicesUpdated() {
//        print("Hey")
    }

}
