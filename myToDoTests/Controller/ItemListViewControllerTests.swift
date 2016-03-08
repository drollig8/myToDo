//
//  ItemListViewControllerTests.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import XCTest
@testable import myToDo

class ItemListViewControllerTests: XCTestCase
{
    var sut: ItemListViewController!
    
    override func setUp()
    {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewControllerWithIdentifier("ItemListViewController") as! ItemListViewController
        _ = sut.view
        
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad()
    {

        XCTAssertNotNil(sut.tableView)
    }
    
    func testViewDidLoad_ShouldSetTableViewDataSource()
    {
        XCTAssertNotNil(sut.tableView.dataSource)
    }
    
    func testViewDidLoad_ShouldSetTableViewDelegate()
    {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }
    
    func testViewDidLoad_ShouldSetDelegateAndDataSourceToSameObject()
    {
     // FAILS   XCTAssertEqual(sut.tableView.dataSource, sut.tableView.delegate)
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider, sut.tableView.delegate as? ItemListDataProvider)

    }
    
    func testSUT_HasAddBarButtonWithSelfAsTarget()
    {
        XCTAssertTrue(sut.navigationItem.rightBarButtonItem?.target === sut)
    }
    
    func test_AddItemPresentsAddItemViewController()
    {
        
    }
}
