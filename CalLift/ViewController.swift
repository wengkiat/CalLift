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
//        print(calendar.getUpcomingEvents()[2])
        let parser = LiftEventParser(event: calendar.getUpcomingEvents()[2])
//        print(parser.parse())

        KoneManager.instance.getLevels(liftId: "lift:9990000508:1:2", completion: {_ in return})
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
