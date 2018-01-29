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
import AVFoundation


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    

    let simulatedAltitude = 70_000.00.feetToMeters
    
    var latOfDevice = 0.0
    var longOfDevice = 0.0
    var altOfDevice = 0.0
    var pitchAndgleOfDevice = 0.0
    var headingOfDevice = 0.0
    var latOfPOI = 0.0
    var longOfPOI = 0.0
    
    var coordsCalculations = Calculation()
    var setOfCoords = [[String]]()
    var setOfLat = [String]()
    var allCoordsTaken = [Date:[Double]]()
    
    
    
    
    
    
    
    // MARK: - Table Items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setOfLat.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        }
        cell!.textLabel?.text = setOfLat[indexPath.row]
        return cell!
    }
    
    
    
    // MARK: - Camera Items
    let captureCoords = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var cameraPreview: AVCaptureVideoPreviewLayer?
    
    func selectInputDevice() {
        let devices = AVCaptureDevice.default(for: AVMediaType.video)  //.defaultDevice(withMediaType: AVMediaTypeVideo)
        if devices?.position == AVCaptureDevice.Position.back {
            backCamera = devices
        }
        currentDevice = backCamera
        do {
            if let currentDevice = currentDevice {
                let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
                captureCoords.addInput(captureDeviceInput)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func beginCamera(){
        cameraPreview = AVCaptureVideoPreviewLayer(session: captureCoords)
        view.layer.addSublayer(cameraPreview!)
        
        
        view.bringSubview(toFront: stackViewOutlet)
        view.bringSubview(toFront: crossHairImage)
        view.bringSubview(toFront: captureButtonOutlet)
        view.bringSubview(toFront: coordTable)
        
        
        cameraPreview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreview?.frame = view.layer.bounds
        captureCoords.startRunning()
    }
    
    @IBOutlet var coordTable: UITableView!
    @IBOutlet var stackViewOutlet: UIStackView!
    @IBOutlet var crossHairImage: UIImageView!
    @IBOutlet var captureButtonOutlet: UIButton!
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
        pitchLabel.text = "Pitch: \(String(format: "%.0f°", pitchAndgleOfDevice))"
        yawLabel.text   = "Yaw: \(String(format: "%.0f°", yaw))"
        self.pitchAndgleOfDevice = pitch
        
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
        headingLabel.text = "Heading: \(String(format: "%.0f", headingOfDevice))"
        self.headingOfDevice = newHeading.trueHeading
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
 
    @IBAction func captureCoordsButton(_ sender: UIButton) {
        getPosition()
        
        let POI_Lat = coordsCalculations.coordsOfPOICalculate(latitudeAngleOfDevice: latOfDevice, longitudeAngleOfDevice: longOfDevice, altitudeOfDevice: simulatedAltitude, pitchAngleOfTheDevice: pitchAndgleOfDevice.degreesToRadians, headingAngleOfTheDevice_TN: headingOfDevice)[0]
        let POI_Long = coordsCalculations.coordsOfPOICalculate(latitudeAngleOfDevice: latOfDevice, longitudeAngleOfDevice: longOfDevice, altitudeOfDevice: simulatedAltitude, pitchAngleOfTheDevice: pitchAndgleOfDevice.degreesToRadians, headingAngleOfTheDevice_TN: headingOfDevice)[1]

        setOfLat.append("\(String(format: "%.4f", POI_Lat)):\(String(format: "%.4f", POI_Long))")
        let lat = coordsCalculations.coordsOfPOICalculate(latitudeAngleOfDevice: latOfDevice, longitudeAngleOfDevice: longOfDevice, altitudeOfDevice: simulatedAltitude, pitchAngleOfTheDevice: pitchAndgleOfDevice.degreesToRadians, headingAngleOfTheDevice_TN: headingOfDevice)[0]
        let long = coordsCalculations.coordsOfPOICalculate(latitudeAngleOfDevice: latOfDevice, longitudeAngleOfDevice: longOfDevice, altitudeOfDevice: simulatedAltitude, pitchAngleOfTheDevice: pitchAndgleOfDevice.degreesToRadians, headingAngleOfTheDevice_TN: headingOfDevice)[1]
        
        verAccLabel.text = "POI Lat: \(String(format: "%.6f", lat))"
        horAccLabel.text = "POI long: \(String(format: "%.6f", long))"
        yawLabel.text   = "Distance: \(String(format: "%.0f°", coordsCalculations.distanceToPOICalculated))"
        
        stackViewOutlet.isHidden = true
        coordTable.reloadData()
        
        print(setOfCoords)
    }
    // call the below function in viewDidLoad()
    func getPosition(){
        if let location = locManager.location {
            let latt = location.coordinate.latitude
            let long = location.coordinate.longitude
            let alt = location.altitude // in meters
            
            
            lattitudeLabel.text = "Lat: \(String(format: "%.2f", latt))"
            longitudeLabel.text = "Long: \(String(format: "%.2f", long))"
            altitudeLabel.text = "Alt: \(String(format: "%.2f", alt))"
            
            verAccLabel.text = ""
            horAccLabel.text = ""
            
            self.latOfDevice = latt
            self.longOfDevice = long
            self.altOfDevice = alt
            
            
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
        selectInputDevice()
        beginCamera()
        
        coordTable.delegate = self
        coordTable.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

