//
//  Calculation.swift
//  Location
//
//  Created by elmo on 1/26/18.
//  Copyright © 2018 Caerus. All rights reserved.
//

import Foundation


struct Calculation {
    
    var latitudeOfDevice: Double = 0.0
    var longitudeOfDevice: Double = 0.0
    var earthRadiusCalculated: Double = 0.0
    let majEarthAxis_WGS84: Double = 6_378_137.0
    let minEarthAxis_WGS84: Double = 6_356_752.314_245
    
    func radiusCorrectionFactor() -> Double {
        let a = 1.0/(self.majEarthAxis_WGS84*self.majEarthAxis_WGS84)
        let b = (tan(self.latitudeOfDevice)*tan(self.latitudeOfDevice)) / (self.minEarthAxis_WGS84*self.minEarthAxis_WGS84)
        let c = Double.squareRoot(a + b)
//        let result = 1.0 / c
//        let radiusCorrectionFactor = (1.0) / (c)
        return radiusCorrectionFactor
    }
    
    
    
    
    
    
}


