//
//  ItemListDataProvider.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import UIKit

enum Section: Int {
    case Todo, Done
}

@objc protocol ItemManagerSettable {
    var itemManager: ItemManager? { get set }
}

let kItemSelectedNotification = "ItemSelectedNotification"

// Warum muss hier das Settable rein und kann ihc nicht einfach DataProbider sagen ist so wie es ist....

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate, ItemManagerSettable
{
    var itemManager:ItemManager?
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemManager = itemManager else {return 0}
        guard let itemSection = Section(rawValue: section) else {fatalError()}
        switch itemSection
        {
        case .Todo: return itemManager.toDoCount ?? 0
        case .Done: return itemManager.doneCount ?? 0
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let itemSection = Section(rawValue: indexPath.section) else {fatalError()}
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        switch itemSection
        {
        case .Todo: cell.configCellWithItem(itemManager!.itemAtIndex(indexPath.row))
        case .Done: cell.configCellWithItem(itemManager!.doneItemAtIndex(indexPath.row))
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        guard let itemSection = Section(rawValue: indexPath.section) else {fatalError()}
        switch itemSection
        {
        case .Todo: return "Check"
        case .Done: return "Uncheck"
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let itemSection = Section(rawValue: indexPath.section) else {fatalError()}
        switch itemSection
        {
        case .Todo: itemManager?.checkItemAtIndex(indexPath.row)
        case .Done: itemManager?.uncheckItemAtIndex(indexPath.row)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let itemSelection = Section(rawValue: indexPath.section) else {fatalError()}
        switch itemSelection {
        case .Todo: NSNotificationCenter.defaultCenter().postNotificationName(kItemSelectedNotification, object: nil, userInfo: ["index":indexPath.row])
        case .Done: break
        }
    }
}
