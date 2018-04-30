//
//  GraphVC.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/28/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import UIKit
import Charts

class GraphVC: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
