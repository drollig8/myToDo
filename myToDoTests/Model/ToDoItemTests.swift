//
//  ToDoItemTests.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import XCTest
@testable import myToDo

class ToDoItemTests: XCTestCase
{
    
    override func setUp()
    {
        super.setUp()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testInit_ShouldTakeTitle()
    {
        let item = ToDoItem(title: "Test title")
        XCTAssertEqual(item.title, "Test title", "Initial value")
    }
    
    func testIinit_ShouldTakeTitleAndAndDescription()
    {
        let item = ToDoItem(title: "Test title", itemDescription: "Test Description")
        XCTAssertEqual(item.description, "Test Description", "initial value for description")
    }
    
    func testIinit_ShouldTakeTitleAndAndDescriptionAndTimeStamp()
    {
        let item = ToDoItem(title: "Test title", itemDescription: "Test Description", timestamp: 0.0)
        XCTAssertEqual(item.timestamp, 0.0, "initial value for timestamp")
    }
    
    func testIinit_ShouldTakeTitleAndAndDescriptionAndTimeStampAndLocation()
    {
        let location = Location(name: "TestName")
        let item = ToDoItem(title: "Test title", itemDescription: "Test Description", timestamp: 0.0, location: location)
        XCTAssertEqual(location.name, item.location?.name, "initial value for location")
    }
    
    func testEqualItems_ShouldBeEqual()
    {
        let firstItem = ToDoItem(title: "first")
        let secondItem = ToDoItem(title: "first")
        
        XCTAssertEqual(firstItem, secondItem)
    }
    
    
    func testWhenLocationDiffers_ShouldNotBeEqual()
    {
        let firstItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 9.9, location: Location(name: "Home"))
        let secondItem = ToDoItem(title: "First title", itemDescription: "First description", timestamp: 9.9, location: Location(name: "Ofice"))
        
        XCTAssertNotEqual(firstItem, secondItem)
    }
    
    func test_HasPlistDictionaryProperty()
    {
        let item = ToDoItem(title: "Home")
        let dictionary = item.plistDict
        
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is NSDictionary)
    }
    
    
    func test_CanBeCreatedFromPlistDictionary()
    {
        let location = Location(name: "Home")
        let item = ToDoItem(title: "Title", itemDescription: "Description", timestamp: 1.0, location: location)
        let dict = item.plistDict
        let recreatedItem = ToDoItem(dict: dict)
        XCTAssertEqual(item, recreatedItem)
    }
    
    /*
    func test_ToDoItemGetSerialized()
    {
        var itemManager: ItemManager? = ItemManager()
    }

    */

}
