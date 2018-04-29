//
//  ListVC.swift
//  MealPlanTracker
//
//  Created by Yehoon on 4/28/18.
//  Copyright © 2018 Yehoon Joo. All rights reserved.
//

import UIKit

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var currentPage = 2
    var datesArray = [String]()
    var typesArray = [String]()
    var defaultsData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        datesArray = defaultsData.stringArray(forKey: "datesArray") ?? [String]()
        typesArray = defaultsData.stringArray(forKey: "typesArray") ?? [String]()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addButton.addTarget(self, action: #selector(segueAddItem), for: .touchUpInside)
    }
    
    //MARK:- Data Storage
    func saveDefaultsData() {
        defaultsData.set(datesArray, forKey: "datesArray")
        defaultsData.set(typesArray, forKey: "typesArray")
    }
    
    //MARK:- Segues
    @objc func segueAddItem() {
        performSegue(withIdentifier: "AddItem", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            let destination = segue.destination as! DetailVC
            let index = tableView.indexPathForSelectedRow!.row
            destination.mealDate = datesArray[index]
            destination.mealType = typesArray[index]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! DetailVC
        if let indexPath = tableView.indexPathForSelectedRow {
            datesArray[indexPath.row] = sourceViewController.mealDate!
            typesArray[indexPath.row] = sourceViewController.mealType!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: datesArray.count, section: 0)
            datesArray.append(sourceViewController.mealDate!)
            typesArray.append(sourceViewController.mealType!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        saveDefaultsData()
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            addButton.isEnabled = true
            editButton.setTitle("Edit", for: .normal)
        } else {
            tableView.setEditing(true, animated: true)
            addButton.isEnabled = false
            editButton.setTitle("Done", for: .normal)
        }
    }
}

extension ListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = datesArray[indexPath.row]
        cell.detailTextLabel?.text = typesArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { // Delete case
        if editingStyle == .delete {
            datesArray.remove(at: indexPath.row)
            typesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveDefaultsData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { // Move case
        let itemToMove = datesArray[sourceIndexPath.row]
        let noteToMove = typesArray[sourceIndexPath.row]
        datesArray.remove(at: sourceIndexPath.row)
        typesArray.remove(at: sourceIndexPath.row)
        datesArray.insert(itemToMove, at: destinationIndexPath.row)
        typesArray.insert(noteToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
}
