//
//  ItemCellTests.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//


import XCTest
@testable import myToDo

class ItemCellTests: XCTestCase
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
        tableView.dataSource = FakeDataSource()
    }
    
    func testSUT_HasNameLabel()
    {
        //let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! ItemCell
        // fails: let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as! ItemCell
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        
        
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func testSUT_HasLocationLabel()
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.locationLabel)
    }
    
    func testConfigWithItem_SetsTitle()
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        cell.configCellWithItem(ToDoItem(title: "Test123", itemDescription: "Test Description", timestamp: 1456150025, location: Location(name: "Home")))
        XCTAssertTrue(cell.titleLabel.text == "Test123")
        XCTAssertTrue(cell.locationLabel.text == "Home")
        XCTAssertTrue(cell.dateLabel.text == "02/22/2016")
    }
    
    func testTitle_ForCheckedTasks_IsStrokeThrough()
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        let item = ToDoItem(title: "First", itemDescription: nil, timestamp: 1456150025, location: Location(name: "Home"))
        cell.configCellWithItem(item, checked: true)
        let attributedString = NSAttributedString(string: "First", attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
        
    }
    
}

extension ItemCellTests
{
    class FakeDataSource: NSObject, UITableViewDataSource
    {
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            return UITableViewCell()
        }
    }
}
