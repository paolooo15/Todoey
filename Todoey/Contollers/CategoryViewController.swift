//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Paolo Vasilev on 3/8/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //goes to AppDelegate grab the persistenContainer and then we grab the reference to the context for that persistenContainer

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
     //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell" ,for: indexPath)
        //creating reusable cell
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell 
    }
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do {
        try context.save()
            //calling this try context.save() once we are ready withh all the changes and we are ready to commit them 
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }

    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
        categories = try context.fetch(request)
        } catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            //whatever user enter in to textField would be the new name of the category
            
            self.categories.append(newCategory)
            //grab a reference - ПРЕПРАТКА to array of category  objects append - ПРИБАВЯМ
            self.saveCategories()
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
   
    
    
    
    
    
    
    
}
