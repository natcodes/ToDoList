//
//  TodoListTableViewController.swift
//  TodoList
//
//  Created by Natalie Nuno on 3/23/18.
//  Copyright © 2018 Natalie Nuno. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController, AddItemTVCDelegate {
    
    // sets db var
    var todo = [TodoList]()
    // datamanager var
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //display data at reload
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
    }
    
    func cancelButtonPressed(by controller: AddViewController) {
        dismiss(animated: true, completion: nil)
        //when pressed by addvc this func is triggered and the page is dismissed.
    }
    
    // ===============  CRUD ========================================
    
                        // CREATE save func
    func itemSaved(by controller: AddViewController, with task: String, date: Date, desc: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {  //if there's an index path sending the info change the prev text to this.
            let addition = todo[ip.row]
            addition.date = date;
            addition.task = task;
            addition.desc = desc;
        }else { // if not from an index path create a new instance and append to the list.
            let item = NSEntityDescription.insertNewObject(forEntityName: "TodoList", into: managedObjectContext) as! TodoList
            item.task = task
            item.date = date
            item.desc = desc
            todo.append(item)
        }
        do { //standard try and save
            try managedObjectContext.save()
        }catch{
            print("\(error)")
        }
        tableView.reloadData() //reload the tableview with the new item.
        dismiss(animated: true, completion: nil) //dismiss the view.
    }
    
    
                    // =================  UPDATE segue and DELETE action  =================

    
    // allows for two options in with the swipe action, edit and delete.
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //performing the edit segue when clicking edit.
        let editAction = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath)-> Void in
            self.performSegue(withIdentifier: "AddEditItemSegue", sender: indexPath)
        }
        
        //deleting the item.
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {(action, indexPath) -> Void in
            let deleteItem = self.todo[indexPath.row]
            self.managedObjectContext.delete(deleteItem)
            do {
                try self.managedObjectContext.save()
            } catch {
                print("\(error)")
            }
            self.todo.remove(at: indexPath.row) //Removes the row so the entire view doesn't have to reload.
            tableView.deleteRows(at: [indexPath], with: .automatic) //deletes the tableview row more efficiently without having to reload.
        }
        editAction.backgroundColor = UIColor.blue
        
        return [editAction, deleteAction]
    }
    
    @IBOutlet var todoListTableView: UITableView!
 
    // ========   READ/FETCH ALL  ====================
    
    func fetchAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        do {
            let results = try managedObjectContext.fetch(request)
            todo = results as! [TodoList]
        } catch {
            print("\(error)")
        }
    }
    
    // PREPARE HANDSHAKE   =========================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController //we go through the nav controller segue
        let addController = navController.topViewController as! AddViewController // nav connects to the addvc
        addController.delegate = self  // this main controller is the addview controller delegate
        
        if let indexPath = sender as? NSIndexPath { // if the request was sent from an index path send the following values from the cell.
            let todos = todo[indexPath.row]         // values for the edit through the prepare.
            addController.taskItem = todos.task!   // taskitem descitem, dateitem in the addvc.swift hold the values while it segues.
            addController.descItem = todos.desc!   // sending the index path allows these items to set in the same cell after editing.
            addController.dateItem = todos.date!
            addController.indexPath = indexPath     //without the indexpath it will add the edit into a new cell.
        }
    }
    
    // sets the format and info for the labels and cell in main VC
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell  //sets the cell
        
        let todoItem = todo[indexPath.row]   //passes particular item into a var todoItem for further manipulation.
            
        cell.taskLabel?.text = todoItem.task
            
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let formattedDate = dateFormatter.string(from: todoItem.date!)
        
        cell.dateLabel.text = formattedDate
            
        cell.descLabel.text = todoItem.desc

        if todoItem.selected {   //gives the checkmark to the selected attribute.
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selects and deselects for the checkmark.
        
        let thisTodo = self.todo[indexPath.row]
        
        thisTodo.selected = !thisTodo.selected   //toggles between true & false, takes the place and true/false if statement.
        
//        if thisTodo.selected {
//            thisTodo.selected = false
//        } else {
//            thisTodo.selected = true
//        }
        do {
            try self.managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    } //number of rows to be displayed in the table.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
