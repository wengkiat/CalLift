//
//  WaitingViewController.swift
//  CalLift
//
//  Created by Edmund Mok on 10/1/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    @IBOutlet weak var liftSquareView: UIView!
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var timeLeftLbl: UILabel!
    // Passed by delegate
    var assignedLift: KoneLift!
    var timer: Timer?
    
    var srcIdx: Int?
    var destIdx: Int?
    
    // Mock
    var maxLevel = KoneManager.instance.floors.count
    var maxHeight = 0

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPollingForLiftUpdates()
        setupBgView()
        setupLiftView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupLiftView() {
        liftSquareView.setBlur(style: .light, corner: 6.0, replaceViewAlpha: true)
        guard srcIdx != nil else {
            NSLog("Not assigned")
            return
        }
        animateToFloor(floor: srcIdx!)
    }
    
    func animateToFloor(floor: Int) {
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseInOut, animations: {
            self.liftSquareView.frame = CGRect(x: self.liftSquareView.frame.origin.x,
                                         y: self.backgroundView.frame.height * CGFloat(1 - (floor/self.maxLevel)),
                                         width: self.liftSquareView.frame.width,
                                         height: self.liftSquareView.frame.height)
        }, completion: nil)
    }
    
    func setupBgView() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "plug-and-play-silicon-valley"))
        imageView.contentMode = .scaleAspectFill
        imageView.bounds = view.bounds
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        imageView.layer.zPosition = -10
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.setBlur(style: .dark, alpha: 0.75)
        self.view.addSubview(imageView)
    }
    
    func startPollingForLiftUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [unowned self] _ in
            KoneManager.instance.getLiftState(liftId: self.assignedLift.id) { state in
                let floorIdx = KoneManager.instance.floors.index(where: {floor in
                    return floor.typicalLevel == state.level
                })
                self.animateToFloor(floor: floorIdx!)
            }
        }
    }

    func stopPollingForLiftUpdates() {
        timer?.invalidate()
    }

}
