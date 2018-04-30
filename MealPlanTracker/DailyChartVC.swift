//
//  DailyChartVC.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/28/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import UIKit
import Charts

class DailyChartVC: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var currentPage = 0
    var mealsArray = [MealInfo]()
    let dateFormatter = DateFormatter()
    var defaultsData = UserDefaults.standard
    
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var dailyTotals = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        loadMealsArrayDefaultsData()
        calculateDailyTotals()
        
        setChart(dataPoints: days, values: dailyTotals)
        
        let xAxis = barChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont(name: "Avenir", size: 16)!//.systemFont(ofSize: 16)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = DayAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
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
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Dollars")
        chartDataSet.setColor(UIColor(red: (145/255.0), green: (22/255.0), blue: (57/255.0), alpha: 1.0))
        let chartData = BarChartData(dataSet: chartDataSet) //BarChartData(xVals: days, dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.chartDescription?.enabled = false
    }
    
    func loadMealsArrayDefaultsData() {
        if let savedArray = defaultsData.object(forKey: "mealsArray") as? Data {
            let decoder = JSONDecoder()
            if let loadedArray = try? decoder.decode([MealInfo].self, from: savedArray) {
                mealsArray = loadedArray
            }
        }
    }
    
    func calculateDailyTotals() {
        for meal in mealsArray {
            let date = dateFormatter.date(from: meal.date)!
            let day = date.dayOfWeek()!
            let index = days.index(of: day)!
            dailyTotals[index] = dailyTotals[index] + meal.amount
        }
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
