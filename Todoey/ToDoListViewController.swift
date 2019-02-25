//
//  ViewController.swift
//  Todoey
//
//  Created by Paolo Vasilev on 2/22/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let  items = defaults.array(forKey: "ToDoListArray") as? [String] {
             //creating that our itemarray to be equal to the new constant defaults, where our NSDATA is saved
            itemArray = items
        }
       
        
        
    
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        //creating the func that creat a number of rows based on our array
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        //Call this method from your data source object when asked to provide a new cell for the table view. This method DEQUEUES an existing cell if one is available, or creates a new one based on the class or nib file you previously registered, and adds it to the table.Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the table view.
    }
    
    //MARK - TableView Dekegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //fucn that show us which row was sellected
        
        //print(itemArray[indexPath.row])
        //creating a func that show us which row we sellected , and also show us in our debug /number or the name of the row/
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        // creating vie code to have a checmark on the list
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        //creating if else statemnt that give us a chance to select or unselect whit checkmark indexPath.
        
        tableView.deselectRow(at: indexPath, animated: true)
        //creating a way when we select a row , to dont stay gray , its just flashing gray to show we selected that one and then disappeared
    
        
    }
    
    //MARK - Add New Items 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        //creating local variable !
    
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        //creat a new alert once we press the + button
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //create an action for the alert that we creat , simply we have to add item
            //print("Success!")\
            self.itemArray.append(textField.text!)
            //adding an item to our item array with focrce ! which means it wont be never nil also just becouse we are in clouse we have to add self. to explicete it where this item array exist
            
            self.defaults.set(self.itemArray,forKey: "ToDoListArray")
            
            self.tableView.reloadData()
            //once we create the new item , making the tableview to reload
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //creating a space for adding a text when we press the + button
            //print(alertTextField.text)
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

