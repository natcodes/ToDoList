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

    
    func cancelButtonPressed(by controller: AddViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // ===============  CRUD ========================================
    func itemSaved(by controller: AddViewController, with task: String, date: Date, desc: String, at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            let addition = todo[ip.row]
            addition.date = date;
            addition.task = task;
            addition.desc = desc;
        }else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "TodoList", into: managedObjectContext) as! TodoList
            print(item)
            item.task = task
            item.date = date
            item.desc = desc
//            todo.append(item)
        }
        do {    //DO TRY TO SAVE ITEM
            try managedObjectContext.save()
        }catch{
            print("\(error)")
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBOutlet var todoListTableView: UITableView!
 
    override func viewDidLoad() { //if 0 items in the db then custom cells wont render.
        super.viewDidLoad()
        do {
            let list = try managedObjectContext.fetch(TodoList.fetchRequest())
            todo = list as! [TodoList]
        } catch {
            print("Error: \(error)")
        }
    }

}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        let todoItem = todo[indexPath.row]
        cell.textLabel!.text = todoItem.task
//        if todoItem.containsObject(self.todo.objectAtIndex(indexPath.row) as! String)
//        {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
