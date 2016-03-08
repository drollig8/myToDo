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

}
