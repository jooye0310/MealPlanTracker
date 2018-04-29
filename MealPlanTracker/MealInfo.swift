//
//  MealInfo.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/29/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import Foundation

class MealInfo: Codable {
    var date: String
    var type: String
    var amount: Double
    
    init(date: String, type: String, amount: Double) {
        self.date = date
        self.type = type
        self.amount = amount
    }
}
