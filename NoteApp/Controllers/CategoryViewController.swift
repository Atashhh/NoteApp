//
//  CategoryViewController.swift
//  NoteApp
//
//  Created by Atash Musazade on 02.03.23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
        
        var categoryArray = [Category]()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadCategories()
        }
        // MARK: - Table View Datasource Methods
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return categoryArray.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            
            cell.textLabel?.text = categoryArray[indexPath.row].name
            
            return cell
        }
        // MARK: - Table View Delegate Methods
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
        }
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! NoteViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArray[indexPath.row]
            }
            
        }
        
        // MARK: - Data Manipulation Methods
        func saveCategories() {
            
            do {
                try context.save()
            } catch {
                print("Error saving category \(error)")
            }
            tableView.reloadData()
        }
        
        func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
            
            do {
                categoryArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context \(error)")
            }
            tableView.reloadData()
        }
        
        // MARK: - Add New Categories
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { action in
                //what will happen once the user clicks the Add Item Button on our UIAlert
                
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                
                self.categoryArray.append(newCategory)
                
                self.saveCategories()
            }
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Create New Category"
                textField = alertTextField
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        
    }
