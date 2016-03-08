//
//  ItemManager.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import Foundation

class ItemManager
{
    private var todoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()
    
    var toDoCount : Int {
        return todoItems.count
    }
    
    var doneCount : Int {
        return doneItems.count
    }
    func addItem(item: ToDoItem)
    {
        if !todoItems.contains(item) {
            todoItems.append(item)
        }
    }
    
    func itemAtIndex(index: Int) -> ToDoItem
    {
        return todoItems[index]
    }
    
    func doneItemAtIndex(index: Int) -> ToDoItem
    {
        return doneItems[index]
    }
    
    func checkItemAtIndex(index: Int)
    {
        let item = todoItems.removeAtIndex(index)
        doneItems.append(item)
    }
    
    func uncheckItemAtIndex(index: Int)
    {
        let item = doneItems.removeAtIndex(index)
        todoItems.append(item)
        
    }
    
    func removeAll()
    {
        todoItems.removeAll()
        doneItems.removeAll()
    }
}