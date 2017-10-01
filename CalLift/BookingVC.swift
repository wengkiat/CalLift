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
        KoneManager.instance.getFloors(completionHandler: showDestinations)
    }
    
    func showDestinations(_ floors: [KoneFloor]) {
        print(floors)
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
        
        self.nextEventView.setBlur(style: .light, alpha: 0.5, replaceViewAlpha: true)
        self.sourceView.setBlur(style: .dark, alpha: 0.5, replaceViewAlpha: true)
        self.destinationView.setBlur(style: .dark, alpha: 0.5, replaceViewAlpha: true)
        
        self.sourceView.setCornerRadius(radius: radius)
        self.nextEventView.setCornerRadius(radius: radius)
        self.destinationView.setCornerRadius(radius: radius)
        
        self.sourceView.setShadow()
        self.nextEventView.setShadow()
        self.destinationView.setShadow()
        
        
    }

    func displayCallNowBtn() {
        if self.callNowBtn != nil {
            return
        }
        let width = view.frame.width * 0.8
        let height = CGFloat(45.0)
        let x = view.frame.width * 0.1
        let y = view.frame.height * 0.9
        let frame = CGRect(x: x, y: y, width: width, height: height)
        self.callNowBtn = ColoredButton(frame: frame,
                                         color: UIColor.clear,
                                         borderColor: UIColor.clear)
        self.callNowBtn!.frame = frame
        self.callNowBtn!.setTitle("Call Now", for: .normal)
        self.callNowBtn!.addTarget(self, action: #selector(self.callNowBtnTouched(_:)), for: .touchUpInside)
        self.callNowBtn!.setBlur(style: .light)
        self.callNowBtn?.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(self.callNowBtn!)
    }
    
    @objc func callNowBtnTouched(_ sender: AnyObject?) {
        if sender === self.callNowBtn {
            print("CALL LIFT NOW")
        }
    }
    

}
