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
    var dateItem: Date?
    var taskItem: String?
    var descItem: String?
    
    var indexPath: NSIndexPath?
    
    weak var delegate: AddItemTVCDelegate?
    
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var descField: UITextView!
    
    @IBOutlet weak var datePick: UIDatePicker!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        let utask = taskTextField.text!
        let udate = datePick.date
        let udesc = descField.text!
        delegate?.itemSaved(by: self, with: utask, date: udate, desc: udesc, at: indexPath) //task: utask doesnt work
    }

    @IBAction func cancelButtonPressed(_ sender: AddViewController) {
        delegate?.cancelButtonPressed(by:self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextField.text = taskItem
        descField.text = descItem
        if let unwrapDate = dateItem {
            datePick.date = unwrapDate
        }
    }
}
