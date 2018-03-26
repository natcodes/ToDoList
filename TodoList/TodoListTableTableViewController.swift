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
    
    var todo = [TodoList]()
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAll()
        tableView.reloadData()
    }
    
    func cancelButtonPressed(by controller: AddViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // ===============  CRUD ========================================
    
                        // CREATE
    func itemSaved(by controller: AddViewController, with task: String, date: Date, desc: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            let addition = todo[ip.row]
            addition.date = date;
            addition.task = task;
            addition.desc = desc;
        }else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "TodoList", into: managedObjectContext) as! TodoList
            item.task = task
            item.date = date
            item.desc = desc
            todo.append(item)
        }
        do {    //DO TRY TO SAVE ITEM
            try managedObjectContext.save()
        }catch{
            print("\(error)")
        }
        dismiss(animated: true, completion: nil)
    }
                    // UPDATE segue and DELETE action

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit") {(action, indexPath)-> Void in
            self.performSegue(withIdentifier: "AddEditItemSegue", sender: indexPath)
            print("edit button pressed")
            }
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {(action, indexPath) -> Void in
            let deleteItem = self.todo[indexPath.row]
            self.managedObjectContext.delete(deleteItem)
            do {
                try self.managedObjectContext.save()
            } catch {
                print("\(error)")
            }
            self.todo.remove(at: indexPath.row)
            tableView.reloadData()
        }
        editAction.backgroundColor = UIColor.blue
        return [editAction, deleteAction]
    }
    
    @IBOutlet var todoListTableView: UITableView!
 
 
    // ========   FETCH ALL  ====================
    
    func fetchAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        do {
            let results = try managedObjectContext.fetch(request)
            todo = results as! [TodoList]
        } catch {
            print("\(error)")
        }
    }
    
    // PREPARE HANDSHAKE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let addController = navController.topViewController as! AddViewController
        addController.delegate = self
        
        if let indexPath = sender as? NSIndexPath {
            let todos = todo[indexPath.row]
            addController.taskItem = todos.task!
            addController.descItem = todos.desc!
            addController.dateItem = todos.date!
            addController.indexPath = indexPath
        }
    }
    
    // sets the format and info for the labels and cell in main VC
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        let todoItem = todo[indexPath.row]
            
        cell.taskLabel?.text = todoItem.task
            
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: todoItem.date!)
//        print(formattedDate)
        cell.dateLabel.text = formattedDate
            
        cell.descLabel.text = todoItem.desc

        if  todoItem.selected  == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thisTodo = self.todo[indexPath.row]
        print(thisTodo.selected)
        
        if thisTodo.selected == true{
            thisTodo.selected = false
        } else {
            thisTodo.selected = true
        }
//        print("row selected")
        do {
            try self.managedObjectContext.save()
        } catch {
            print("\(error)")
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
