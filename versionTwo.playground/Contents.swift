//: Playground - noun: a place where people can play

import UIKit
import Foundation
import Darwin

extension Double {
    //http://www.kylesconverter.com
    var radiansToDegrees: Double { return self * 180 / Double.pi }
    var degreesToRadians: Double { return self * Double.pi / 180 }
    var metersToFeet: Double { return self * 3.2808399 }
    var feetToMeters: Double { return self * 0.3048 }
    var metersToNauticalMiles: Double { return self * 0.0005396118248380001 }
}

struct Calculation {
    
    var latitudeAngleOfDevice: Double                       // 𝜙 (1)    - degrees
    var longitudeAngleOfDevice: Double                      // λ (1)    - degrees
    var altitudeOfDevice: Double                            // ζ        - meters
    var pitchAngleOfTheDevice: Double                       // β        - degrees
    let majEarthAxis_WGS84: Double = 6_378_137.0            // maj      - meters
    let minEarthAxis_WGS84: Double = 6_356_752.314_245      // min      - meters
    var earthRadiusCalculated: Double = 0.0                 // x        - meters
    var cSideOfTraingleCalculated: Double = 0.0             // c        - meters
    var headingAngleOfTheDevice_TN: Double = 0.0            // 𝜃        - degrees
    var centralAngleBetweenCalculated: Double = 0.0         // α        - radians??
    var distanceToPOICalculated: Double = 0.0               // d         - meters??
    var lattitudeAngleOfPOI: Double = 0.0                   //
    var longitudeAngleOfPOI: Double = 0.0                   //
    
    init(latitudeAngleOfDevice: Double, longitudeAngleOfDevice: Double, altitudeOfDevice: Double, pitchAngleOfTheDevice: Double, headingAngleOfTheDevice_TN: Double){

        //Local Variable names in initializer functions are just placeholders to more easily break up the correction equations
        //1: radiusCorrectionFactor()
        let a1 = 1.0/(self.majEarthAxis_WGS84*self.majEarthAxis_WGS84)
        let b1 = (tan(latitudeAngleOfDevice.degreesToRadians)*tan(latitudeAngleOfDevice.degreesToRadians)) / (self.minEarthAxis_WGS84*self.minEarthAxis_WGS84)
        let c1 = 1.0/((a1+b1).squareRoot())
        let d1 = c1/(cos(latitudeAngleOfDevice.degreesToRadians))
        print("\(d1): earthRadiusCalculated: in meters")
        for _ in 0..<2 {
            print("")
        }
        
        //2: centralAngleSolver()
        let c = d1 + altitudeOfDevice
        print(c)
        let a = d1
        print(a)
        let A = pitchAngleOfTheDevice.degreesToRadians
        print(A.radiansToDegrees)
        //Quadratic Equation
        let aQuad = 1.0
        let bQuad = -2.0*c*cos(A)
        let cQuad = (c*c)-(a*a)
        let quadSol1 = (-(bQuad)+((bQuad*bQuad)-(4*aQuad*cQuad)).squareRoot())/2
        let quadSol2 = (-(bQuad)-((bQuad*bQuad)-(4*aQuad*cQuad)).squareRoot())/2
       
        
        
        print(quadSol1.metersToNauticalMiles)
        print(quadSol2.metersToNauticalMiles)
        let b = quadSol2
        let B = asin((sin(A)*b)/a)
        print(B)
 
        //3: distanceSolver()
        let a3 = d1*B
        print("\(a3.metersToNauticalMiles): distanceToPOICalculated: in NM")
        print("\(a3): distanceToPOICalculated: in meters")

        //equation #4 is used as a common sense check of the answers
        //4: max distance (line of sight to the horizon) you can see from current altitude
        let a4 = ((c*c)-(d1*d1)).squareRoot()
        let maxPitchOfDevice = asin(d1/c)
        let maxCentralAngle = asin(a4/d1)
        let maxLineOfSightDistance = d1*maxCentralAngle
        for _ in 0..<2 {
            print("")
        }
        print("\(maxLineOfSightDistance.metersToNauticalMiles): Max distance")
        print("\(maxPitchOfDevice.radiansToDegrees): Max possible view angle")
        print("\(maxCentralAngle.radiansToDegrees): Max central Angle in degrees")
        for _ in 0..<2 {
            print("")
        }
        
        //5: coordinate for POI solver
        let a5 = headingAngleOfTheDevice_TN.degreesToRadians
        let lattitudeAngleOfPOI = a3*sin(a5) + latitudeAngleOfDevice.degreesToRadians
        let longitudeAngleOfPOI = (a3*cos(a5)/cos(latitudeAngleOfDevice.degreesToRadians))+longitudeAngleOfDevice.degreesToRadians
        print("\(lattitudeAngleOfPOI): POI lat")
        print("\(longitudeAngleOfPOI): POI long")
        
        self.latitudeAngleOfDevice = latitudeAngleOfDevice
        self.longitudeAngleOfDevice = longitudeAngleOfDevice
        self.altitudeOfDevice = altitudeOfDevice
        self.pitchAngleOfTheDevice = pitchAngleOfTheDevice
        self.earthRadiusCalculated = d1
        self.centralAngleBetweenCalculated = quadSol2
        self.cSideOfTraingleCalculated = c
        self.distanceToPOICalculated = a3
        self.lattitudeAngleOfPOI = lattitudeAngleOfPOI
        self.longitudeAngleOfPOI = longitudeAngleOfPOI
        
    }
}

var latitudeAngleOfDevice = 37.0
var longitudeAngleOfDevice = 90.0
var altitudeOfDevice = 70_000.0
var pitchAngleOfTheDevice = 5.0
var headingAngleOfTheDevice_TN = 165.0

var calc = Calculation(latitudeAngleOfDevice: latitudeAngleOfDevice, longitudeAngleOfDevice: longitudeAngleOfDevice, altitudeOfDevice: altitudeOfDevice.feetToMeters, pitchAngleOfTheDevice: pitchAngleOfTheDevice, headingAngleOfTheDevice_TN: headingAngleOfTheDevice_TN)





