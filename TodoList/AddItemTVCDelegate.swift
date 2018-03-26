//
//  AddItemTVCDelegate.swift
//  TodoList
//
//  Created by Natalie Nuno on 3/23/18.
//  Copyright © 2018 Natalie Nuno. All rights reserved.
//


import Foundation
import UIKit

protocol AddItemTVCDelegate: class {
    func itemSaved(by controller: AddViewController, with task: String, date: Date, desc: String, at indexPath: NSIndexPath?)
    func cancelButtonPressed(by controller: AddViewController)
}

