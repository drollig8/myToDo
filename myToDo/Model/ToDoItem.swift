//
//  ToDoItem.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import Foundation

struct ToDoItem: Equatable
{
    let title: String
    let description: String?
    let timestamp: Double?
    let location: Location?
    
    private let titleKey = "titleKey"
    private let descriptionKey = "descriptionKey"
    private let timestampeKey = "timestampeKey"
    private let locationKey = "locationKey"
    
    var plistDict: NSDictionary {
        var dict = [String:AnyObject]()
        dict[titleKey] = title
        if let description = description {
            dict[descriptionKey] = description
        }
        if let timestamp = timestamp {
            dict[timestampeKey] = timestamp
        }
        if let location = location {
            let locationDict = location.plistDict
            dict[locationKey] = locationDict
        }

        return dict
    }
    
    init(title: String, itemDescription: String? = nil, timestamp: Double? = nil, location: Location? = nil)
    {
        self.title = title
        self.description = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
    
    init?(dict: NSDictionary)
    {
        guard let title = dict[titleKey] as? String else {fatalError()}
        self.title = title
        
        self.description = dict[descriptionKey] as? String
        self.timestamp = dict[timestampeKey] as? Double
        if let locationDict = dict[locationKey] as? NSDictionary {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
    }

}

func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool
{
    if lhs.title != rhs.title {
        return false
    }
    if lhs.location != rhs.location {
        return false
    }
    return true
}