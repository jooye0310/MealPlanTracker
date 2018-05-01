//
//  SummaryVC.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/28/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mealPlanTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var currentDailyAverageLabel: UILabel!
    @IBOutlet weak var versusLabel: UILabel!
    @IBOutlet weak var recommendedDailyAverageLabel: UILabel!
    @IBOutlet weak var expectedEndDateLabel: UILabel!
    
    var currentPage = 1
    var mealPlanAmount = 0.0
    var mealsArray = [MealInfo]()
    
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    var defaultsData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        mealPlanTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        
        setupTextField(forTextField: mealPlanTextField)
        setupTextField(forTextField: startDateTextField)
        setupTextField(forTextField: endDateTextField)
        
//        loadDefaultsData(forTextField: mealPlanTextField)
//        loadDefaultsData(forTextField: startDateTextField)
        startDatePicker.date = Date()
        startDateTextField.text = dateFormatter.string(from: startDatePicker.date)
        loadDefaultsData(forTextField: endDateTextField)
        endDateTextField.text = dateFormatter.string(from: endDatePicker.date)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadDefaultsData(forTextField: mealPlanTextField)
    }
    
    //MARK:- Default data setup
    func saveDefaultsData(forTextField textField: UITextField) {
        if textField == mealPlanTextField {
            mealPlanAmount = Double(mealPlanTextField.text!)!
            defaultsData.set(mealPlanAmount, forKey: "mealPlanAmount")
//        } else if textField == startDateTextField {
//            defaultsData.set(startDateTextField.text, forKey: "startDate")
        } else if textField == endDateTextField {
            defaultsData.set(endDateTextField.text, forKey: "endDate")
        }
    }
    
    func loadDefaultsData(forTextField textField: UITextField) {
        if textField == mealPlanTextField {
            mealPlanAmount = defaultsData.double(forKey: "mealPlanAmount")
            mealPlanTextField.text = String(format: "%.2f", ceil(mealPlanAmount * 100) / 100)
//        } else if textField == startDateTextField {
//            startDateTextField.text = defaultsData.string(forKey: "startDate") ?? ""
        } else if textField == endDateTextField {
            endDateTextField.text = defaultsData.string(forKey: "endDate") ?? ""
            if endDateTextField.text != "" {
                endDatePicker.date = dateFormatter.date(from: endDateTextField.text!)!
            } else {
                endDatePicker.date = dateFormatter.date(from: "5/15/2018")!
            }
        }
    }
    
    func loadMealsArrayDefaultsData() {
        if let savedArray = defaultsData.object(forKey: "mealsArray") as? Data {
            let decoder = JSONDecoder()
            if let loadedArray = try? decoder.decode([MealInfo].self, from: savedArray) {
                mealsArray = loadedArray
            }
        }
        sortMealsArray()
    }
    
    func sortMealsArray() {
        mealsArray.sort {
            if $0.date != $1.date {
                let dateArray1 = $0.date.components(separatedBy: "/")
                let dateArray2 = $1.date.components(separatedBy: "/")
                if dateArray1[2] == dateArray2[2] {
                    if dateArray1[0] == dateArray2[0] {
                        let date1 = Int(dateArray1[1])!
                        let date2 = Int(dateArray2[1])!
                        return date1 > date2
                    } else {
                        return dateArray1[0] > dateArray2[0]
                    }
                } else {
                    return dateArray1[2] > dateArray2[2]
                }
            } else {
                var typeA: Int
                switch $0.type {
                case "Breakfast":
                    typeA = 0
                case "Lunch":
                    typeA = 1
                case "Dinner":
                    typeA = 2
                default: // Other
                    typeA = 3
                }
                
                var typeB: Int
                switch $1.type {
                case "Breakfast":
                    typeB = 0
                case "Lunch":
                    typeB = 1
                case "Dinner":
                    typeB = 2
                default: // Other
                    typeB = 3
                }
                
                return typeA > typeB
            }
        }
    }
    
    //MARK:- Text field setup
    func setupTextField(forTextField currentTextField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        if currentTextField == startDateTextField {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDoneButtonPressed))
            startDatePicker.datePickerMode = .date
            startDateTextField.inputView = startDatePicker
        } else if currentTextField == endDateTextField {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDoneButtonPressed))
            endDatePicker.datePickerMode = .date
            endDateTextField.inputView = endDatePicker
        } else if currentTextField == mealPlanTextField {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(mealDoneButtonPressed))
        }
        toolbar.setItems([doneButton], animated: false)
        currentTextField.inputAccessoryView = toolbar
    }
    
    @objc func mealDoneButtonPressed() {
        self.view.endEditing(true)
        mealPlanAmount = Double(mealPlanTextField.text!)!
        saveDefaultsData(forTextField: mealPlanTextField)
    }
    
    @objc func startDoneButtonPressed() {
        startDateTextField.text = dateFormatter.string(from: startDatePicker.date)
        saveDefaultsData(forTextField: startDateTextField)
        self.view.endEditing(true)
    }
    
    @objc func endDoneButtonPressed() {
        endDateTextField.text = dateFormatter.string(from: endDatePicker.date)
        saveDefaultsData(forTextField: endDateTextField)
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn   range: NSRange, replacementString string: String) -> Bool {
        let computationString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let arrayOfSubStrings = computationString.components(separatedBy: ".")
        if textField == mealPlanTextField {
            if arrayOfSubStrings.count == 1 && computationString.count > 4 { // up to 4 digits before decimal
                return false
            } else if arrayOfSubStrings.count == 2 {
                let stringPostDecimal = arrayOfSubStrings[1]
                return stringPostDecimal.count <= 2 // up to 2 digits after decimal
            }
        }
        return true
    }
    
    //MARK:- Calculation functions
    func calculateCurrentAverage() -> Double {
        loadMealsArrayDefaultsData()
        var datesSet = Set<String>()
        var mealsTotal = 0.0
        if mealsArray.isEmpty {
            return 0.0
        } else {
            for meal in mealsArray {
                datesSet.insert(meal.date)
                mealsTotal = mealsTotal + meal.amount
            }
            let days = datesSet.count
            let currentDailyAverage = mealsTotal / Double(days)
            return currentDailyAverage
        }
    }
    
    func calculateRecommendedAverage() -> Double {
        let daysLeft = calculateDateDifference()
        let recommendedDailyAverage = mealPlanAmount / Double(daysLeft)
        return recommendedDailyAverage
    }
    
    func calculateExpectedDate(_ currentAverage: Double) -> String {
        if mealPlanAmount == 0.0 {
            let date = Date()
            return dateFormatter.string(from: date)
        }
        let days = Int(round(mealPlanAmount / currentAverage))
        var dateComponent = DateComponents()
        let monthsToAdd = days / 30
        let daysToAdd = days % 30
        dateComponent.month = monthsToAdd
        dateComponent.day = daysToAdd
        dateComponent.year = 0
        let expectedDate = Calendar.current.date(byAdding: dateComponent, to: startDatePicker.date)
        let expectedDateString = dateFormatter.string(from: expectedDate!)
        return expectedDateString
    }
    
    func calculateDateDifference() -> Int {
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        let dateDifference = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        return dateDifference
    }

    @IBAction func startDateTapped(_ sender: UITapGestureRecognizer) {
        startDatePicker.date = dateFormatter.date(from: startDateTextField.text!)!
    }
    
    @IBAction func endDateTapped(_ sender: UITapGestureRecognizer) {
        endDatePicker.date = dateFormatter.date(from: endDateTextField.text!)!
    }
    
    @IBAction func startDateChanged(_ sender: UITextField) {
        startDateTextField.text = dateFormatter.string(from: startDatePicker.date)
    }
    
    @IBAction func endDateChanged(_ sender: UITextField) {
        endDateTextField.text = dateFormatter.string(from: endDatePicker.date)
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        let recommendedAverage = calculateRecommendedAverage()
        recommendedDailyAverageLabel.text = "$\(String(format: "%.2f", ceil(recommendedAverage * 100) / 100))"
        
        let currentAverage = calculateCurrentAverage()
        currentDailyAverageLabel.text = "$\(String(format: "%.2f", ceil(currentAverage * 100) / 100))"
        
        let expectedDate = calculateExpectedDate(currentAverage)
        expectedEndDateLabel.text = expectedDate
        
        if currentAverage > recommendedAverage {
            versusLabel.text = ">"
        } else if currentAverage < recommendedAverage {
            versusLabel.text = "<"
        } else {
            versusLabel.text = "="
        }
    }
}
