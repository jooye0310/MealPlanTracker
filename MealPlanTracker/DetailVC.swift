//
//  DetailVC.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/28/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var mealDate: String?
    var mealType: String?
    var mealAmount: Double?
    let datePicker = UIDatePicker()
    let typePicker = UIPickerView()
    var typeArray = ["Breakfast", "Lunch", "Dinner", "Other"]
    var typePickerRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(textFieldType: "Date")
        setupTextField(textFieldType: "Type")
        setupTextField(textFieldType: "Amount")
        
        typePicker.dataSource = self
        typePicker.delegate = self
        
        if let mealDate = mealDate { // Editing existing item
            dateTextField.text = mealDate
            titleLabel.text = "Edit Meal"
        } else { // Creating new item
            titleLabel.text = "New Meal"
        }
        if let mealType = mealType {
            typeTextField.text = mealType
        }
        enableDisableSaveButton()
        dateTextField.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindFromSave" {
            mealDate = dateTextField.text
            mealType = typeTextField.text
        }
    }
    
    func setupTextField(textFieldType type: String) {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem()
        var currentTextField = UITextField()
        switch type {
        case "Date":
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
            toolbar.setItems([doneButton], animated: false)
            datePicker.datePickerMode = .date
            currentTextField = dateTextField
            currentTextField.inputView = datePicker
        case "Type":
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(typeDonePressed))
            toolbar.setItems([doneButton], animated: false)
            currentTextField = typeTextField
            currentTextField.inputView = typePicker
        default: // Amount
            doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(amountDonePressed))
            currentTextField = amountTextField
        }
        toolbar.setItems([doneButton], animated: false)
        currentTextField.inputAccessoryView = toolbar
    }
    
    @objc func dateDonePressed() {
        // format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
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
