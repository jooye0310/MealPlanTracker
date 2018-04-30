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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mealPlanTextField.delegate = self
        setupTextField(forTextField: mealPlanTextField)
        startDateTextField.delegate = self
        setupTextField(forTextField: startDateTextField)
        endDateTextField.delegate = self
        setupTextField(forTextField: endDateTextField)
    }
    
    //MARK:- Text field setup
    func setupTextField(forTextField currentTextField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: false)
        currentTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonPressed() {
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
