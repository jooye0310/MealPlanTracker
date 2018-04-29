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
    var mealsArray = [MealInfo]()
    var defaultsData = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        loadDefaultsData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addButton.addTarget(self, action: #selector(segueAddItem), for: .touchUpInside)
    }
    
    //MARK:- Data Storage
    func saveDefaultsData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(mealsArray) {
            defaultsData.set(encoded, forKey: "mealsArray")
        }
        //defaultsData.set(mealsArray, forKey: "mealsArray")
    }
    
    func loadDefaultsData() {
        if let savedArray = defaultsData.object(forKey: "mealsArray") as? Data {
            let decoder = JSONDecoder()
            if let loadedArray = try? decoder.decode([MealInfo].self, from: savedArray) {
                mealsArray = loadedArray
            }
        }
    }
    
    //MARK:- Segues
    @objc func segueAddItem() {
        performSegue(withIdentifier: "AddItem", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            let destination = segue.destination as! DetailVC
            let index = tableView.indexPathForSelectedRow!.row
            destination.mealInfo = mealsArray[index]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        let sourceViewController = segue.source as! DetailVC
        if let indexPath = tableView.indexPathForSelectedRow {
            mealsArray[indexPath.row] = sourceViewController.mealInfo!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: mealsArray.count, section: 0)
            mealsArray.append(sourceViewController.mealInfo!)
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
        return mealsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = mealsArray[indexPath.row].date
        cell.detailTextLabel?.text = "\(mealsArray[indexPath.row].type): $\(mealsArray[indexPath.row].amount)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { // Delete case
        if editingStyle == .delete {
            mealsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveDefaultsData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) { // Move case
        let itemToMove = mealsArray[sourceIndexPath.row]
        mealsArray.remove(at: sourceIndexPath.row)
        mealsArray.insert(itemToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
}
