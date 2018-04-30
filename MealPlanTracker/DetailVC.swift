//
//  DetailVC.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/28/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var mealInfo: MealInfo?
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    let typePicker = UIPickerView()
    var typeArray = ["Breakfast", "Lunch", "Dinner", "Other"]
    var typePickerRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround() 
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // setup text fields
        setupDateTextField()
        
        typePicker.dataSource = self
        typePicker.delegate = self
        setupTypeTextField()
        
        amountTextField.delegate = self
        setupAmountTextField()
        
        if let mealInfo = mealInfo { // Editing existing item
            titleLabel.text = "Edit Meal"
            dateTextField.text = mealInfo.date
            datePicker.date = dateFormatter.date(from: mealInfo.date)!
            typeTextField.text = mealInfo.type
            amountTextField.text = String(mealInfo.amount)
        } else { // Creating new item
            titleLabel.text = "New Meal"
        }
        enableDisableSaveButton()
        //dateTextField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            mealInfo = MealInfo(date: dateTextField.text!, type: typeTextField.text!, amount: Double(amountTextField.text!)!)
        }
    }
    
    //MARK:- Text field functions
    func setupDateTextField() {
        // toolbar
        let dateToolbar = UIToolbar()
        dateToolbar.sizeToFit()
        let dateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateToolbar.setItems([dateDoneButton], animated: false)
        dateTextField.inputAccessoryView = dateToolbar
    }
    
    func setupTypeTextField() {
        let typeToolbar = UIToolbar()
        typeToolbar.sizeToFit()
        let typeDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(typeDonePressed))
        typeTextField.inputView = typePicker
        typeToolbar.setItems([typeDoneButton], animated: false)
        typeTextField.inputAccessoryView = typeToolbar
    }
    
    func setupAmountTextField() {
        let amountToolbar = UIToolbar()
        amountToolbar.sizeToFit()
        let amountDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(amountDonePressed))
        amountToolbar.setItems([amountDoneButton], animated: false)
        amountTextField.inputAccessoryView = amountToolbar
    }
    
    @objc func dateDonePressed() {
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func typeDonePressed() {
        typeTextField.text = typeArray[typePickerRow]
        self.view.endEditing(true)
    }
    
    @objc func amountDonePressed() {
        self.view.endEditing(true)
    }
    
    // limits the textField input to two decimals
    func textField(_ textField: UITextField, shouldChangeCharactersIn   range: NSRange, replacementString string: String) -> Bool {
        let digitBeforeDecimal = 3
        let digitAfterDecimal = 2
        let computationString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let arrayOfSubStrings = computationString.components(separatedBy: ".")
        if arrayOfSubStrings.count == 1 && computationString.count > digitBeforeDecimal {//
            return false
        } else if arrayOfSubStrings.count == 2 {
            let stringPostDecimal = arrayOfSubStrings[1]
            return stringPostDecimal.count <= digitAfterDecimal
        }
        return true
    }
    
    //MARK:- Button functions
    func enableDisableSaveButton() {
        if let dateTextFieldCount = dateTextField.text?.count, dateTextFieldCount > 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func dateTextFieldChanged(_ sender: UITextField) {
        enableDisableSaveButton()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typePickerRow = row
        typeTextField.text = typeArray[row]
    }
}
