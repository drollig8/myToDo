//
//  ItemManagerTests.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import XCTest
import CoreLocation

@testable import myToDo

class ItemManagerTests: XCTestCase
{
    var sut: ItemManager!
    
    override func setUp()
    {
        super.setUp()
        sut = ItemManager()
    }
    
    override func tearDown()
    {
        sut.removeAll()
        sut = nil

        super.tearDown()
    }
    
    func testToDoCount_Initially_ShouldBeZero()
    {
        XCTAssertEqual(sut.toDoCount, 0)
    }
    
    func testToDoCount_AfterAddingOneItem_ShouldBeOne()
    {
    
        sut.addItem(ToDoItem(title: "Test"))
        XCTAssertEqual(sut.toDoCount, 1)
    }
    
    func testItemAtIndex_ShouldReturnItemAtIndex()
    {
        let item = ToDoItem(title: "Test")
        sut.addItem(item)
        let returnedItem = sut.itemAtIndex(0)
        
        XCTAssertEqual(item, returnedItem)
    }
    
    func testCheckingItem_ChangesCountOfTodoAndOfDoneItems()
    {
        let item = ToDoItem(title: "Test")
        sut.addItem(item)
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.toDoCount, 0)
        XCTAssertEqual(sut.doneCount, 1)
    }
    
    func terstCheckingItem_RemovesItFromTheTodoItemList()
    {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        sut.addItem(firstItem)
        sut.addItem(secondItem)
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.itemAtIndex(0), secondItem)
        
    }
    
    func testDoneItemAtIndex_ShouldReturnPreviouslyCheckedValue()
    {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        sut.addItem(firstItem)
        sut.addItem(secondItem)
        sut.checkItemAtIndex(0)
        let returnedItem = sut.doneItemAtIndex(0)
        XCTAssertEqual(firstItem, returnedItem)
    }
    
    func testRemoveAllItems_ShouldResultInCountsToBeZero()
    {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        sut.addItem(firstItem)
        sut.addItem(secondItem)
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.toDoCount, 1)
        XCTAssertEqual(sut.doneCount, 1)
        sut.removeAll()
        XCTAssertEqual(sut.toDoCount, 0)
        XCTAssertEqual(sut.doneCount, 0)
        
    }
    
    func testAddingTheSameItem_DoesNotIncreaseCount()
    {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "First")
        sut.addItem(firstItem)
        XCTAssertEqual(sut.toDoCount, 1)
        sut.addItem(secondItem)
        XCTAssertEqual(sut.toDoCount, 1)
    }
    
    func test_ToDoItemGetSerialized()
    {
        var itemManager: ItemManager? = ItemManager()
        let firstItem = ToDoItem(title: "First")
        itemManager?.addItem(firstItem)
        
        let secondItem = ToDoItem(title: "Second")
        itemManager?.addItem(secondItem)
        
        NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationWillResignActiveNotification, object: nil)
        
        itemManager = nil
        
        XCTAssertNil(itemManager)
        
        itemManager = ItemManager()
        
        XCTAssertEqual(itemManager?.itemAtIndex(0), firstItem)
        XCTAssertEqual(itemManager?.itemAtIndex(1), secondItem)
    }
}

