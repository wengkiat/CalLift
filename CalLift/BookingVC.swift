//
//  BookingVC.swift
//  CalLift
//
//  Created by Leon Mak on 1/10/17.
//  Copyright © 2017 Edmund Mok. All rights reserved.
//

import UIKit
import EventKit

class BookingVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nextEventView: UIView!
    @IBOutlet weak var nextEventLbl: UILabel!
    @IBOutlet weak var nextEventLocation: UILabel!
    @IBOutlet weak var nextEventMinLbl: UILabel!
    @IBOutlet weak var nextEventSecLbl: UILabel!
    
    @IBOutlet weak var sourceLiftArrivingLbl: UILabel!
    @IBOutlet weak var sourceView: UIView!
    @IBOutlet weak var sourceDescription: UILabel!
    @IBOutlet weak var sourceArea: UILabel!
    
    @IBOutlet weak var destinationView: UIView!
    @IBOutlet weak var destinationDescription: UILabel!
    @IBOutlet weak var destinationLocation: UILabel!
    
    var callNowBtn: ColoredButton?
    
    var countdownSec: Double = 10 * 60 + 5
    var countdownTimer: Timer?
    
    var scanState = ScanState.stopped
    
    let calendar = LiftCalendar()
    let scanner = BluetoothScanner()
    
    var selectedLift: KoneLift?
    var srcFloorIndex: Int?
    var destFloorIndex = Constants.Mock.Destination.index

    var assignedLift: KoneLift!
    var nextEvent: EKEvent!
    
    var picker = UIPickerView()
    var btnClicked = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupView()
        setupPicker()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - SETUP
    // MARK: Data
    func setupData() {
        setupBluetooth()
        setupEventCalendar()
        setupTimer()
    }
    
    func setupPicker() {
        picker.frame.origin.x = 0
        picker.frame.origin.y = 0
        picker.frame = view.frame
        picker.setBlur(style: .light, alpha: 0.8, replaceViewAlpha: true)
        picker.isHidden = true
        view.addSubview(picker)
        KoneManager.instance.picker = picker

        picker.delegate = self
        picker.dataSource = self
    }
    
    func setupTimer() {
        self.countdownSec = nextEvent.startDate.timeIntervalSince(Date())
        self.countdownTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(countdownTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    func setupBluetooth() {
        scanner.delegate = self
    }
    
    func setupEventCalendar() {
        self.nextEvent = calendar.upsertCalendarAndEvent()
        nextEventLbl.text = nextEvent?.title
        nextEventLocation.text = nextEvent?.location
    }
    
    @objc func countdownTime() {
        self.countdownSec -= 1
        self.updateEventCountdownLbl()
        if self.countdownSec == 0 {
            self.countdownTimer?.invalidate()
        }
        if countdownSec < 600 {
            startScan()
        }
    }
    
    // MARK: Views
    func setupView() {
        setupBgView()
        setupDestinationLabel()
        setupEventViews()
        setupCallNowBtn()
        
        if Constants.isDemo {
            populateInitialData()
        }
    }

    func setupDestinationLabel() {
        self.destinationDescription.text = self.nextEvent.location!
    }
    
    func populateInitialData() {
        updateEventCountdownLbl()
        initializeSourceLiftLbl()
    }
    
    func initializeSourceLiftLbl() {
        sourceArea.text = ""
        sourceDescription.text =  ""
    }
    
    func padTime(_ timeDigits: Int) -> String {
        if timeDigits < 10 {
            return "0" + String(timeDigits)
        }
        return String(timeDigits)
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
    // MARK: Button handler
    @objc func callNowBtnTouched(_ sender: AnyObject?) {
        if sender === self.callNowBtn! {
             // TODO: Replace mock data
            guard srcFloorIndex != nil else { return }
            let srcName = KoneManager.instance.floors[srcFloorIndex!].name
            let destName = KoneManager.instance.floors[destFloorIndex].name
            self.callNowBtn?.setTitle("Assigning Lift", for: .normal)
            self.callNowBtn?.setBlur(style: .dark, corner: 6.0, alpha: 0.4)
            KoneManager.instance.bookLift(from: srcName, to: destName, completion: { lift in
                self.assignedLift = lift
                self.performSegue(withIdentifier: "BookingSegue", sender: nil)
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! WaitingViewController
        dest.assignedLift = self.assignedLift
        dest.srcIdx = self.srcFloorIndex
        dest.destIdx = self.destFloorIndex
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
        let startDate = calendar.selectedEvent?.startDate
        let interval = startDate!.timeIntervalSinceReferenceDate
        let url = URL(string: "calshow:\(interval)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func chooseSourceLocation() {
        btnClicked = "src"
        picker.reloadAllComponents()
        print("Choose source location")
        picker.isHidden = false
    }
    
    func chooseDestinationLocation() {
        btnClicked = "dest"
        picker.reloadAllComponents()
        print("Choose dest Location")
        picker.isHidden = false
    }
    
    // MARK: Time state
    func updateEventCountdownLbl() {
        let minute = Int(floor(countdownSec / 60))
        let seconds = Int(countdownSec.truncatingRemainder(dividingBy: 60.0))
        self.nextEventMinLbl.text = "\(padTime(minute))"
        self.nextEventSecLbl.text = "\(padTime(seconds))"
    }

    // MARK: BLE state
    // stop -> start
    func startScan() {
        if scanState == .stopped, scanner.manager.state == .poweredOn {
            scanState = .started
            startScanningAnimation()
            // acquires fast so delay to simulate finding
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                UIView.animate(withDuration: 1, animations: {
                    self.scanner.startScanning()
                })
            })
        }
    }
    // stop -> start
    func startScanningAnimation() {
        UIView.animate(withDuration: 1, animations: {
            self.sourceView.backgroundColor = Constants.Colors.flatYellow
            self.sourceDescription.text = "BLE Scanning"
            self.sourceArea.text = "Finding nearest lift & floor"
        })
    }
    
    // start -> found
    func foundSourceAnimation(area: String, floor: String) {
        self.scanState = .found
        UIView.animate(withDuration: 0.5, animations: {
            self.sourceView.backgroundColor = Constants.Colors.flatGreen
            self.callNowBtn?.backgroundColor = Constants.Colors.flatGreen
            self.sourceDescription.text = floor
            self.sourceArea.text = area
            self.sourceLiftArrivingLbl.text = "Lift arriving at"
        })
    }

    // MARK: - Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let rows = KoneManager.instance.floors.count
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.btnClicked == "src" {
            sourceDescription.text = KoneManager.instance.floors[row].name
        } else if self.btnClicked == "dest" {
            destinationDescription.text = KoneManager.instance.floors[row].name
        }
        self.view.endEditing(true)
        picker.isHidden = true
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return KoneManager.instance.floors[row].name
    }

}

extension BookingVC: BluetoothScannerDelegate {
    
    func readyToScan() {
        NSLog("Scanner is ready")
    }
    
    // start -> found
    func foundUUID(_ uuid: String) {
        NSLog("Found uuid \(uuid)")
        var srcFloor = 0
        for digit in uuid {
            if digit == "A" {
                srcFloor += 1
            }
        }
        self.srcFloorIndex = srcFloor
        // TODO: Replace with iBeacon BLE Message
        foundSourceAnimation(area: Constants.Mock.Source.area, floor: Constants.Mock.Source.floor)
        scanner.stopScanning()
    }
    
}
