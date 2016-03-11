//
//  DetailViewControllerTests.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//


import XCTest
import MapKit
@testable import myToDo

class DetailViewControllerTests: XCTestCase
{
    var sut: DetailViewController!
    var tableView: UITableView!
    var controller: ItemListViewController!
    
    override func setUp() {
        
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        _ = sut.view

    }
    
    override func tearDown() {
        sut.itemInfo?.0.removeAll()
        super.tearDown()
    }
    
    func test_HastTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
    }
    
    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
    }
    
    func testSettingItemInfo_SetsTextsToLabel()
    {
        let coordinate = CLLocationCoordinate2D(latitude: 51.2277, longitude: 6.7735)
        let itemManager = ItemManager()
        itemManager.addItem(ToDoItem(title: "The title", itemDescription: "The description", timestamp: 1456150025, location: Location(name: "Home", coordinate: coordinate)))
        sut.itemInfo = (itemManager, 0)
        
        // this is like doing sut.viewDidAppear(...)
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, "The title")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.locationLabel.text, "Home")
        XCTAssertEqual(sut.descriptionLabel.text, "The description")
        XCTAssertEqualWithAccuracy(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
    }
    
    func testCheckItem_ChecksItemInItemManager()
    {
        let itemManager = ItemManager()
        itemManager.addItem(ToDoItem(title: "The title"))
        sut.itemInfo = (itemManager, 0)
        sut.checkItemButton(self)
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
        
    }
}
