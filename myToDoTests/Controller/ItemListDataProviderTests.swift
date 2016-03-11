//
//  ItemListDataProviderTests.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//


import XCTest
@testable import myToDo

class ItemListDataProviderTests: XCTestCase
{
    var sut: ItemListDataProvider!
    var tableView: UITableView!
    var controller: ItemListViewController!
    
    override func setUp()
    {
        super.setUp()
        sut = ItemListDataProvider()
        sut.itemManager = ItemManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewControllerWithIdentifier("ItemListViewController") as! ItemListViewController

        
        _ = controller.view
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
        
    }
    
    override func tearDown() {
        sut.itemManager?.removeAll()
        sut.itemManager = nil
        super.tearDown()
    }
    
    func testNumberOfSections_IsTwo()
    {
        let numberOfSections = tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
    }
    
    func testNumberOfRowsInFirstSection_IsToDoCount()
    {
        
        sut.itemManager?.addItem(ToDoItem(title: "Test"))
        
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 1)
        
        sut.itemManager?.addItem(ToDoItem(title: "Test1"))
        tableView.reloadData()
     
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 2)
    }
    
    func testNumberOfRowsInSecondSection_IsDoneCount()
    {
        
        sut.itemManager?.addItem(ToDoItem(title: "Test"))
        
        sut.itemManager?.checkItemAtIndex(0)
        
        sut.itemManager?.addItem(ToDoItem(title: "Test1"))
        sut.itemManager?.checkItemAtIndex(0)
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRowsInSection(0), 0)
        XCTAssertEqual(tableView.numberOfRowsInSection(1), 2)
    }

    func testCellForRow_ReturnsItemCell()
    {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        tableView.reloadData()
        
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
        
        XCTAssertTrue(cell is ItemCell)
    }
    
    func testCellForRow_DequeuesCell()
    {
        /*
        let mockTableView = MockTableView()
        mockTableView.dataSource = sut
        
        mockTableView.registerClass(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        */
        let mockTableView = MockTableView.mockTableViewWithDataSource(sut)
        sut.itemManager?.addItem(ToDoItem(title: "Test"))
        
        mockTableView.reloadData()
        
        _ = mockTableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0))
        
        
        XCTAssertTrue(mockTableView.cellGotDequeued)
    }
    
    func testConfigCell_GetsCalledInCellForRow()
    {
        let mockTableView = MockTableView()
        mockTableView.dataSource = sut
        
        mockTableView.registerClass(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
        
        let item = ToDoItem(title: "Test")
        sut.itemManager?.addItem(item)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! MockItemCell
        
        XCTAssertNotNil(cell.todoItem)
        XCTAssertEqual(cell.todoItem, item)
        
    }
    
    func testCellInSectionTwo_GetsConfiguredWithDoneItem()
    {
        let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 300, height: 400), style: .Plain)
        mockTableView.dataSource = sut
        
        mockTableView.registerClass(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
        
        let firstItem = ToDoItem(title: "FirstTest")
        let secondItem = ToDoItem(title: "SecondTest")
        
        sut.itemManager?.addItem(firstItem)
        sut.itemManager?.addItem(secondItem)
        sut.itemManager?.checkItemAtIndex(1)
        
        mockTableView.reloadData()
        
        let cell = mockTableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 1)) as! MockItemCell
        
        XCTAssertNotNil(cell.todoItem)
        XCTAssertEqual(cell.todoItem, secondItem)
        
    }
    
    func testDeletionButtonInFirstSection_ShowsTitleCheck()
    {
        let title = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertEqual(title, "Check")
    }
    
    func DIStestDataSourceAndDelegate_AreNotTheSameObject()
    {
        XCTAssertTrue(tableView.dataSource is ItemListDataProvider)
        XCTAssertTrue(tableView.delegate is ItemListDataProvider)
        XCTAssertNotEqual(tableView.dataSource as? ItemListDataProvider, tableView.delegate as? ItemListDataProvider)
    }
    
    func testDeletionButtonInFirstSection_ShowsTitleUncheck()
    {
        let title = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 1))
        XCTAssertEqual(title, "Uncheck")
        
    }
    
    func testCheckingAnItem_ChecksItInTheItemManager()
    {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        tableView.dataSource?.tableView?(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        XCTAssertEqual(sut.itemManager?.toDoCount, 0)
        XCTAssertEqual(sut.itemManager?.doneCount, 1)
    }
    
    func testUnCheckingAnItem_UnchecksItemInTheItemManager()
    {
        sut.itemManager?.addItem(ToDoItem(title: "First"))
        tableView.dataSource?.tableView?(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        tableView.dataSource?.tableView?(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 1))
        XCTAssertEqual(sut.itemManager?.toDoCount, 1)
        XCTAssertEqual(sut.itemManager?.doneCount, 0)
    
    
    }
}

extension ItemListDataProviderTests
{
    class MockTableView: UITableView
    {
        var cellGotDequeued = false
        override func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            cellGotDequeued = true
            return super.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        }
        
        class func mockTableViewWithDataSource(dataSource: UITableViewDataSource) -> MockTableView
        {
            let mockTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 300, height: 400), style: .Plain)
            mockTableView.dataSource = dataSource
            mockTableView.registerClass(MockItemCell.self, forCellReuseIdentifier: "ItemCell")
            return mockTableView
        }
    }
    
    class MockItemCell: ItemCell
    {
        var todoItem: ToDoItem!// = false
        
        override func configCellWithItem(item: ToDoItem, checked: Bool = false)
        {
            
            todoItem = item
        }
    }
    
    

    
}
