//: Playground - noun: a place where people can play

import UIKit


extension Double {
    //http://www.kylesconverter.com
    var radiansToDegrees: Double { return self * 180 / Double.pi }
    var degreesToRadians: Double { return self * Double.pi / 180 }
    var metersToFeet: Double { return self * 3.2808399 }
    var feetToMeters: Double { return self * 0.3048 }
    var metersToNauticalMiles: Double { return self * 0.0005396118248380001 }
}


