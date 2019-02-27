//
//  ViewController.swift
//  Todoey
//
//  Created by Paolo Vasilev on 2/22/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)

        
        if let  items = defaults.array(forKey: "ToDoListArray") as? [Item] {
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
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        //set cell accessoryType depending on whether item.done is true , if it is true then set it to .checkmark or if it is not true set it to .none //instend to if else statment//
        
        return cell
        //Call this method from your data source object when asked to provide a new cell for the table view. This method DEQUEUES an existing cell if one is available, or creates a new one based on the class or nib file you previously registered, and adds it to the table.Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the table view.
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //fucn that show us which row was sellected
        
        //print(itemArray[indexPath.row])
        //creating a func that show us which row we sellected , and also show us in our debug /number or the name of the row/
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        // creating vie code to have a checmark on the list
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //creating the checkmark so if itemarray is = !- make the oposite , so if            itemarray is true = !false

       
        tableView.reloadData()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//             tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
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
            //print("Success!")
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
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

