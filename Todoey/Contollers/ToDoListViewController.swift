//
//  ViewController.swift
//  Todoey
//
//  Created by Paolo Vasilev on 2/22/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //creating obejct that provide interface to the file system using default file manager userDomainMask is users home directory place where we gonna save the personal item assosiate with this current app  /first is bc its array and we want to grab the first item / /.appendigPathComponent is creating our own Plist. !!!/*1 - making global constant in other for use to write a data .!!!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // seeing where our data is saving ... creating a path to where our data is saved
        

//        if let  items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//             //creating that our itemarray to be equal to the new constant defaults, where our NSDATA is saved
    
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
        
        //*print(itemArray[indexPath.row])
        //creating a func that show us which row we sellected , and also show us in our debug /number or the name of the row/
        
        //*tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        // creating vie code to have a checmark on the list
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //creating the checkmark so if itemarray is = !- make the oposite , so if            itemarray is true = !false
        
        saveItems()
        //caling saveitems!
        
//  *      if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//   *          tableView.cellForRow(at: indexPath)?.accessoryType = .none
//    *    } else {
//     *        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//      *  }
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
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            //adding an item to our item array with focrce ! which means it wont be never nil also just becouse we are in clouse we have to add self. to explicete it where this item array exist .append adds new item and the end of the array 
            
           self.saveItems()
            //bc we call the function but we are in closure and we have to use self.
            
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
    
    func saveItems() {
        //*2 let encoder = PropertyListEncoder() when using encoda
        
        do {
            
           try context.save()
            //*2 let data = try encoder.encode(itemArray)
            //encode our data into propertylist
            //*2 try data.write(to: dataFilePath!)
            //write data to in our case dataFilePath and in other for that we have to !!!move our constant outside the class , so we have to make it GLOBAL /market as *1/!!!
        } catch {
        //*2    print("Error encoding item array,\(error)")
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        //once we create the new item , making the tableview to reload
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil ) {
        // - creating external "with" parameter and internal "request" peramater is using isde this block of code , external is using when we call the func
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
           request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request) // - "fletch" - ДОСТАВЯМ
        } catch {
            print("Error fetching data from context\(error)")
        }
        
        tableView.reloadData()
        //reload the tabeview with update we made it
    }
    
  
}

    //MARK - Search Bar methods
 
extension TodoListViewController: UISearchBarDelegate {
    //creating extension to our class , so we can more easy find out if we have some issues with the search bar.Extending the functionality
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //requesting the data from our itemArray
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        // request out  predicate taking from data whatever we type into searche bar an show us object’s attribute name is equal to value passed in [cd] stands for "c"-for capital or lower case , and "d" for letters in franch or german such as ë í etc.
        
       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        // sort the date on the way we want .. in this case we sort it in alphabetical order
       
        loadItems(with: request, predicate: predicate)
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

