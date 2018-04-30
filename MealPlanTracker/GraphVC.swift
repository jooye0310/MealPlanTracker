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
    var months: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        months = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0]
        
        setChart(dataPoints: months, values: unitsSold)
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Avenir", size: 16)!//.systemFont(ofSize: 16)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = DayAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " %"
        leftAxisFormatter.positiveSuffix = " %"
        
        let leftAxis = barChartView.leftAxis
        leftAxis.labelFont = UIFont(name: "Avenir", size: 12)!
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = barChartView.rightAxis
        rightAxis.enabled = false
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i]) //BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Percent")
        chartDataSet.setColor(UIColor(red: (145/255.0), green: (22/255.0), blue: (57/255.0), alpha: 1.0))
        let chartData = BarChartData(dataSet: chartDataSet) //BarChartData(xVals: months, dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.chartDescription?.enabled = false
    }
}
