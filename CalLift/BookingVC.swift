//
//  BookingVC.swift
//  CalLift
//
//  Created by Leon Mak on 1/10/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import UIKit

class BookingVC: UIViewController {

    @IBOutlet weak var nextEventView: UIView!
    @IBOutlet weak var nextEventLbl: UILabel!
    @IBOutlet weak var nextEventLocation: UILabel!
    @IBOutlet weak var nextEventStartScanLbl: UILabel!
    @IBOutlet weak var nextEventCountdownLbl: UILabel!
    
    @IBOutlet weak var sourceView: UIView!
    @IBOutlet weak var sourceDescription: UILabel!
    @IBOutlet weak var sourceLocation: UILabel!
    
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var destinationDescription: UILabel!
    @IBOutlet weak var destinationLocation: UILabel!
    
    var callNowBtn: ColoredButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        KoneManager.instance.getFloors(completionHandler: showDestinations)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - SETUP
    // MARK: Data
    func showDestinations(_ floors: [KoneFloor]) {
        print(floors)
    }
    
    
    // MARK: Views
    func setupView() {
        setupBgView()
        setupEventViews()
        setupCallNowBtn()
    }
    
    @objc func showDestinations(_ dict: [String: Any]) {
        print(dict.getItems())
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
    
    func setupEventViews() {
        let radius = CGFloat(6.0)
        
        self.nextEventView.setBlur(style: .light, corner: 6, alpha: 0.5, replaceViewAlpha: true, id: "cal")
        self.sourceView.setBlur(style: .dark, corner: 6, alpha: 0.5, replaceViewAlpha: true, id: "src")
        self.destinationView.setBlur(style: .dark, corner: 6, alpha: 0.5, replaceViewAlpha: true, id: "dest")
        
        self.sourceView.setCornerRadius(radius: radius)
        self.nextEventView.setCornerRadius(radius: radius)
        self.destinationView.setCornerRadius(radius: radius)
        
        self.sourceView.setShadow()
        self.nextEventView.setShadow()
        self.destinationView.setShadow()
    }

    func setupCallNowBtn() {
        if self.callNowBtn != nil {
            return
        }
        let width = view.frame.width * 0.8
        let height = CGFloat(45.0)
        let x = view.frame.width * 0.1
        let y = view.frame.height * 0.9
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let btnColor = UIColor.white.withAlphaComponent(0.24)
        self.callNowBtn = ColoredButton(frame: frame,
                                         color: btnColor,
                                         borderColor: UIColor.clear)
        self.callNowBtn!.frame = frame
        self.callNowBtn!.setTitle("Call Lift Now", for: .normal)
        self.callNowBtn!.addTarget(self, action: #selector(self.callNowBtnTouched(_:)), for: .touchUpInside)
        self.callNowBtn!.layer.cornerRadius = 6.0
        self.callNowBtn?.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(self.callNowBtn!)
    }
    
    // MARK: - UPDATE
    @objc func callNowBtnTouched(_ sender: AnyObject?) {
        if sender === self.callNowBtn!.subviews.last {
            print("CALL LIFT NOW")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            print("No touch")
            return
        }
        
        let touchLocation = touch.location(in: self.view)
        if nextEventView.frame.contains(touchLocation) {
            openNextEventCalendar()
        } else if sourceView.frame.contains(touchLocation) {
            chooseSourceLocation()
        } else if destinationView.frame.contains(touchLocation) {
            chooseDestinationLocation()
        }
    }
    
    func openNextEventCalendar() {
        print("Open calendar")
    }
    
    func chooseSourceLocation() {
        print("Choose source location")
        
    }
    
    func chooseDestinationLocation() {
        print("Choose dest Location")
    }

}
