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
    let datePicker = UIDatePicker()
    var defaultsData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealPlanTextField.delegate = self
        
        startDateTextField.delegate = self
        
        endDateTextField.delegate = self
        
        
        setupTextField(forTextField: mealPlanTextField)
        setupTextField(forTextField: startDateTextField)
        setupTextField(forTextField: endDateTextField)
        
        loadDefaultsData(forTextField: mealPlanTextField)
        loadDefaultsData(forTextField: startDateTextField)
        loadDefaultsData(forTextField: endDateTextField)
    }
    
    //MARK:- Default data setup
    func saveDefaultsData(forTextField textField: UITextField) {
        if textField == mealPlanTextField {
            defaultsData.set(mealPlanTextField.text, forKey: "mealPlanAmount")
        } else if textField == startDateTextField {
            defaultsData.set(startDateTextField.text, forKey: "startDate")
        } else if textField == endDateTextField {
            defaultsData.set(endDateTextField.text, forKey: "endDate")
        }
    }
    
    func loadDefaultsData(forTextField textField: UITextField) {
        if textField == mealPlanTextField {
            mealPlanTextField.text = defaultsData.string(forKey: "mealPlanAmount") ?? ""
        } else if textField == startDateTextField {
            startDateTextField.text = defaultsData.string(forKey: "startDate") ?? ""
        } else if textField == endDateTextField {
            endDateTextField.text = defaultsData.string(forKey: "endDate") ?? ""
        }
    }
    
    //MARK:- Text field setup
    func setupTextField(forTextField currentTextField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        var doneButton = UIBarButtonItem()
        if currentTextField == startDateTextField {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDoneButtonPressed))
            datePicker.datePickerMode = .date
            startDateTextField.inputView = datePicker
        } else if currentTextField == endDateTextField {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDoneButtonPressed))
            datePicker.datePickerMode = .date
            endDateTextField.inputView = datePicker
        } else if currentTextField == mealPlanTextField {
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(mealDoneButtonPressed))
        }
        toolbar.setItems([doneButton], animated: false)
        currentTextField.inputAccessoryView = toolbar
    }
    
    @objc func mealDoneButtonPressed() {
        self.view.endEditing(true)
        saveDefaultsData(forTextField: mealPlanTextField)
    }
    
    @objc func startDoneButtonPressed() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        startDateTextField.text = dateFormatter.string(from: datePicker.date)
        saveDefaultsData(forTextField: startDateTextField)
        self.view.endEditing(true)
    }
    
    @objc func endDoneButtonPressed() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        endDateTextField.text = dateFormatter.string(from: datePicker.date)
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
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
    }
}
