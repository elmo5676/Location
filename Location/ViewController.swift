//
//  ViewController.swift
//  Location
//
//  Created by elmo on 1/25/18.
//  Copyright © 2018 Caerus. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion


class ViewController: UIViewController, CLLocationManagerDelegate {

    
    // < # placeholder_text/code #>

    // MARK: - Initial info.plist setup for camera usage
    // Privacy - Camera Usage Description   :   This App needs access to the camera for the view sight.
    // Privacy - Motion Usage Description   :   This application needs your motion to determine the coordinates of the view sight.
    
    // MARK: - Pitch, Roll, Yaw
    // CLLocationManagerDelegate - add to class declaration
    // Add the 3 functions in the viewController main body and call getOrientation() in viewDidLoad()
    let motionManager = CMMotionManager()
    func outputRPY(data: CMDeviceMotion){
        let rpyattitude = motionManager.deviceMotion!.attitude
        let roll    = rpyattitude.roll * (180.0 / Double.pi)
        let pitch   = rpyattitude.pitch * (180.0 / Double.pi)
        let yaw     = rpyattitude.yaw * (180.0 / Double.pi)
        rollLabel.text  = "Roll: \(String(format: "%.0f°", roll))"
        pitchLabel.text = "Pitch: \(String(format: "%.0f°", pitch))"
        yawLabel.text   = "Yaw: \(String(format: "%.0f°", yaw))"
    }
    func getOrientation(){
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {(motionData: CMDeviceMotion?, NSError) -> Void in self.outputRPY(data: motionData!)
            if (NSError != nil){
                print("\(String(describing: NSError))")
        }})}
    
    
    
    // MARK: - Initial info.plist setup for location services
    // Privacy - Location Always Usage Description  :   This application needs your location to determine the coordinates of the view sight.
    // Privacy - Location When In Use Usage Description :   This application needs your location to determine the coordinates of the view sight.
    
    // MARK: - Lattitude, Longitude, Altitude, Heading and more.
    // CLLocationManagerDelegate - add to class declaration
    
    let locManager = CLLocationManager()
    // Heading readings tend to be widely inaccurate until the system has calibrated itself
    // Return true here allows iOS to show a calibration view when iOS wants to improve itself
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    // This function will be called whenever your heading is updated.
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingLabel.text = "Heading: \(String(format: "%.0f", newHeading.trueHeading))"
    }
    // call the below function in viewDidLoad()
    func getpositionPermission(){
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        locManager.distanceFilter = kCLDistanceFilterNone
        locManager.headingFilter = kCLHeadingFilterNone
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.headingOrientation = .portrait
        locManager.delegate = self
        locManager.startUpdatingHeading()
        locManager.startUpdatingLocation()
    }
    // call the below function in viewDidLoad()
    func getPosition(){
        if let location = locManager.location {
            let latt = location.coordinate.latitude
            let long = location.coordinate.longitude
            let alt = location.altitude // in meters
            let accuracyAlt = location.verticalAccuracy
            let accuracyHorizontal = location.horizontalAccuracy
            
            lattitudeLabel.text = "Lat: \(String(format: "%.2f", latt))"
            longitudeLabel.text = "Long: \(String(format: "%.2f", long))"
            altitudeLabel.text = "Alt: \(String(format: "%.2f", alt))"
            verAccLabel.text = "Vert Acc: \(String(format: "%.2f", accuracyAlt))"
            horAccLabel.text = "Horizontal Acc: \(String(format: "%.2f", accuracyHorizontal))"
            
            /* - additional information available
             let course = location.course
             let accuracy = location.horizontalAccuracy
             let speed = location.speed
             let time = location.timestamp
             */
        }
    }
    
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var lattitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var pitchLabel: UILabel!
    @IBOutlet var rollLabel: UILabel!
    @IBOutlet var yawLabel: UILabel!
    @IBOutlet var verAccLabel: UILabel!
    @IBOutlet var horAccLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getpositionPermission()
        getOrientation()
        getPosition()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

