
//
//  PageObservation.swift
//  FoodTime
//
//  Created by floriane sanchis on 24/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit

protocol PageObservation: class {
    
    func getParentUIPageViewController(parentRef: UIPageViewController)
}
