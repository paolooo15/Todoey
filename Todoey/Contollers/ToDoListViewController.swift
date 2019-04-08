//
//  ViewController.swift
//  Todoey
//
//  Created by Paolo Vasilev on 2/22/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //creating obejct that provide interface to the file system using default file manager userDomainMask is users home directory place where we gonna save the personal item assosiate with this current app  /first is bc its array and we want to grab the first item / /.appendigPathComponent is creating our own Plist. !!!/*1 - making global constant in other for use to write a data .!!!
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // seeing where our data is saving ... creating a path to where our data is saved
        

//        if let  items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//             //creating that our itemarray to be equal to the new constant defaults, where our NSDATA is saved
    
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        //creating the func that creat a number of rows based on our array
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
       if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            //set cell accessoryType depending on whether item.done is true , if it is true then set it to .checkmark or if it is not true set it to .none //instend to if else statment//
       } else {
        cell.textLabel?.text = "No Items added"
        }
        
        return cell
        //Call this method from your data source object when asked to provide a new cell for the table view. This method DEQUEUES an existing cell if one is available, or creates a new one based on the class or nib file you previously registered, and adds it to the table.Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table.The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the table view.
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //fucn that show us which row was sellected
        
        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                //realm.delete(item) - deleting data from realm
                item.done = !item.done
                //creating check mark so if item.done its check /true/ = make it uncheck and if its unchchecked = ! - make it cheked
            }
            } catch {
                print("Error saving donre status,\(error)")
            }
        }
        
    tableView.reloadData()
        //updating data with realm!!!
    
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dataCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            //read data with realm
            
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
    
    
    //MARK - Model Manupulation Methods
    

    func loadItems() {
        // - creating external "with" parameter and internal "request" peramater is using isde this block of code , external is using when we call the func

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//           request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request) // - "fletch" - ДОСТАВЯМ
//        } catch {
//            print("Error fetching data from context\(error)")
//        }

        tableView.reloadData()
        //reload the tabeview with update we made it
    }
    
  
}

    //MARK - Search Bar methods
 
extension TodoListViewController: UISearchBarDelegate {
    //creating extension to our class , so we can more easy find out if we have some issues with the search bar.Extending the functionality
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dataCreated", ascending: true)
        //Querying data base search bar or simply filter the searchbar
        
        tableView.reloadData()
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // cleaning searchbar from what we search previous and with loadItems we get back to original list that we have

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                //making the search bar to be not the first respond which makse the cursor and the keyboard dissmiss
            }

        }
    }
}


