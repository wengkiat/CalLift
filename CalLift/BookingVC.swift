//
//  BookingVC.swift
//  CalLift
//
//  Created by Leon Mak on 1/10/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import UIKit

class BookingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        KoneManager.instance.getFloors(completionHandler: showDestinations)
    }

    func showDestinations(_ floors: [KoneFloor]) {
        print(floors)
    }

}
