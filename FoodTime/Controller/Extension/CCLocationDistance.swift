//
//  CCLocationDistance.swift
//  FoodTime
//
//  Created by floriane sanchis on 02/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationDistance {
    
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }
    
    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
    
    func conversionInUserMetric() -> String
    {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale.current
        return formatter.string(from: Measurement(value: self, unit: UnitLength.meters))
    }
}
