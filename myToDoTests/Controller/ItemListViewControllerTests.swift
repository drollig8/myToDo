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
        XCTAssertNil(sut.presentedViewController)
        guard let addButton = sut.navigationItem.rightBarButtonItem else {fatalError();return}
        UIApplication.sharedApplication().keyWindow?.rootViewController = sut
        sut.performSelector(addButton.action, withObject: addButton)
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
    }
    
    func test_InputViewControllerSharesItemManager() {
        XCTAssertNil(sut.presentedViewController)
        guard let addButton = sut.navigationItem.rightBarButtonItem else {fatalError();return}
        UIApplication.sharedApplication().keyWindow?.rootViewController = sut
        sut.performSelector(addButton.action, withObject: addButton)
        
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        let inputVC = sut.presentedViewController as! InputViewController
        XCTAssertTrue(inputVC.itemManager === sut.itemManager)
    }
    
    
    func testViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func testSUT_ReloadsTableViewOnDidAppear() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertTrue(mockTableView.reloadDataGotCalled)
    }
    
    func testSelectingACell_SendsNotification() {
        let item = ToDoItem(title: "First")
        sut.itemManager.addItem(item)  // The Main Controller initiates ItemManager()
        
        expectationForNotification(kItemSelectedNotification, object: nil) { (notification) -> Bool in
            guard let index = notification.userInfo?["index"] as? Int else {return false}
            return index == 0
        }
        let tableView = sut.tableView
        tableView.delegate?.tableView!(tableView, didSelectRowAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        waitForExpectationsWithTimeout(3, handler: nil)
    }
    
    func testItemSelectedNotification_PushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController:sut)
        UIApplication.sharedApplication().keyWindow?.rootViewController = sut
        _ = sut.view
        NSNotificationCenter.defaultCenter().postNotificationName(kItemSelectedNotification, object: self, userInfo: ["index":1])
        
        guard let detailVC = mockNavigationController.pushedViewController as? DetailViewController else {XCTFail();return}
        
        guard let index = detailVC.itemInfo?.1 else {XCTFail();return}
        
        _ = detailVC.view
        
        XCTAssertNotNil(detailVC.titleLabel)
        XCTAssertTrue(detailVC.itemInfo?.0 === sut.itemManager)
        XCTAssertEqual(index, 1)
    }

}

extension ItemListViewControllerTests {
    
    class MockTableView: UITableView {
        
        var reloadDataGotCalled = false
        override func reloadData() {
            reloadDataGotCalled = true
        }
    }
    
    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        override func pushViewController(viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: true)
        }
    }
}