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
    // ~/Library/Developer/Xcode/UserData/CodeSnippets/
    
    
    // MARK: - Initial info.plist setup for camera usage
    // Privacy - Camera Usage Description   :   This App needs access to the camera for the view sight.
    // Privacy - Motion Usage Description   :   This application needs your motion to determine the coordinates of the view sight.
    
    // MARK: - Pitch, Roll, Yaw
    // CLLocationManagerDelegate - add to class declaration
    // Add the 3 functions in the viewController main body and call getOrientation() in viewDidLoad()
    let motionManager = CMMotionManager()
    func startDeviceMotionUpdates(using referenceFrame: CMAttitudeReferenceFrame, to queue: OperationQueue, withHandler handler: @escaping CMDeviceMotionHandler){
    }
    func outputRPY(data: CMDeviceMotion){
        let rpyattitude = motionManager.deviceMotion!.attitude
        let roll    = rpyattitude.roll * (180.0 / Double.pi)
        let pitch   = rpyattitude.pitch * (180.0 / Double.pi)
        let yaw     = rpyattitude.yaw * (180.0 / Double.pi)
        rollLabel.text  = "Roll: \(String(format: "%.2f°", roll))"
        pitchLabel.text = "Pitch: \(String(format: "%.2f°", pitch))"
        yawLabel.text   = "Yaw: \(String(format: "%.2f°", yaw))"
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
    // call the below function in viewDidLoad()
    let locationManager = CLLocationManager()
    func getposition(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        if let heading = locationManager.heading {
            print(heading.timestamp)
            headingLabel.text = String(describing: heading.trueHeading)
        }
        if let location = locationManager.location {
            let latt = location.coordinate.latitude
            let long = location.coordinate.longitude
            let alt = location.altitude // in meters
            /* - additional information available
            let course = location.course
            let accuracy = location.horizontalAccuracy
            let speed = location.speed
            let time = location.timestamp
            */
            lattitudeLabel.text = "Lat: \(String(format: "%.1f", latt))"
            longitudeLabel.text = "Long: \(String(format: "%.2f", long))"
            altitudeLabel.text = "Alt: \(String(format: "%.3f", alt))"
        }
    }
    
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var lattitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var pitchLabel: UILabel!
    @IBOutlet var rollLabel: UILabel!
    @IBOutlet var yawLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getposition()
        getOrientation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

