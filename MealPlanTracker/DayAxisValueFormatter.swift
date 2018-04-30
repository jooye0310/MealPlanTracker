//
//  DayAxisValueFormatter.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/30/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import Foundation
import Charts

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    
    override init() {
        super.init()
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var day = ""
        switch value {
        case 0.0:
            day = "Sun"
        case 1.0:
            day = "Mon"
        case 2.0:
            day = "Tue"
        case 3.0:
            day = "Wed"
        case 4.0:
            day = "Thu"
        case 5.0:
            day = "Fri"
        case 6.0:
            day = "Sat"
        default:
            day = "ERROR"
        }
        return day
    }
}
