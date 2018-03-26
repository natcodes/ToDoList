//
//  AddViewController.swift
//  TodoList
//
//  Created by Natalie Nuno on 3/23/18.
//  Copyright © 2018 Natalie Nuno. All rights reserved.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var datePick: UIDatePicker!
    
    // the following vars hold the edit values meanwhile the segue happens.
    var dateItem: Date?
    var taskItem: String?
    var descItem: String?
    var indexPath: NSIndexPath? // no longer NSindex
    
    weak var delegate: AddItemTVCDelegate?
    
    // loading the text to be edited onto the additemVC.
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextField.text = taskItem  //taskItem, descItem, dateItem are teh vars used when creating the item in the mainVC
        descField.text = descItem  //
        if let unwrapDate = dateItem { // safe unwrap non optional, Date
            datePick.date = unwrapDate
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let utask = taskTextField.text!
        let udate = datePick.date
        let udesc = descField.text!
        delegate?.itemSaved(by: self, with: utask, date: udate, desc: udesc, at: indexPath) //task: utask doesnt work
    }

    @IBAction func cancelButtonPressed(_ sender: AddViewController) {
        delegate?.cancelButtonPressed(by:self)
    }

}
