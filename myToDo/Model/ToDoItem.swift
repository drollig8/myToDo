//
//  ToDoItem.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

struct ToDoItem
{
    let title: String
    let description: String?
    let timestamp: Double?
    let location: Location?
    
    init(title: String, itemDescription: String? = nil, timestamp: Double? = nil, location: Location? = nil)
    {
        self.title = title
        self.description = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
}