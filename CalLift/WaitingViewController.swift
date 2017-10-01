//
//  WaitingViewController.swift
//  CalLift
//
//  Created by Edmund Mok on 10/1/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    // Passed by delegate
    var assignedLift: KoneLift!
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func startPollingForLiftUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [unowned self] _ in
            KoneManager.instance.getLiftState(liftId: self.assignedLift.id) { state in
                print(state)
            }
        }
    }

    func stopPollingForLiftUpdates() {
        timer?.invalidate()
    }

}
