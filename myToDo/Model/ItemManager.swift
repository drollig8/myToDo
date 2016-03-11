//
//  ItemManager.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import UIKit

class ItemManager:NSObject
{
    
    // Vorteil an einem Struct ist, man kann es ganz wunderbar debuggen.
    
    private var todoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()
    
    var toDoPathURL: NSURL {
        
        let fileURLs = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        guard let documentURL = fileURLs.first else {fatalError()}
        return documentURL.URLByAppendingPathComponent("todolist.plist")
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "save", name: UIApplicationWillResignActiveNotification, object: nil)
        
        print("Initialising ItemManager")
        
        if let nsToDoItems = NSArray(contentsOfURL: toDoPathURL) {
            print(nsToDoItems)
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! NSDictionary)  {
                    
                    todoItems.append(toDoItem)
                }
            }
        }
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        save()
    }
    
    var toDoCount : Int {
        return todoItems.count
    }
    
    var doneCount : Int {
        return doneItems.count
    }
    
    func addItem(item: ToDoItem) {
        if !todoItems.contains(item) {
            todoItems.append(item)
        }
    }
    
    func itemAtIndex(index: Int) -> ToDoItem {
        return todoItems[index]
    }
    
    func doneItemAtIndex(index: Int) -> ToDoItem {
        return doneItems[index]
    }
    
    func checkItemAtIndex(index: Int) {
        let item = todoItems.removeAtIndex(index)
        doneItems.append(item)
    }
    
    func uncheckItemAtIndex(index: Int) {
        let item = doneItems.removeAtIndex(index)
        todoItems.append(item)
        
    }
    
    func removeAll() {
        todoItems.removeAll()
        doneItems.removeAll()
    }
    
    func save() {
        var nsToDoItems = [AnyObject]()
        
        for item in todoItems {
            nsToDoItems.append(item.plistDict)
        }
        
        if nsToDoItems.count > 0 {
            (nsToDoItems as NSArray).writeToURL(toDoPathURL, atomically: true)
        } else {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(toDoPathURL)
            } catch {
                print(error)
            }
        }
    }
}