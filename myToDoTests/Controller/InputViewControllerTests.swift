//
//  InputViewControllerTests.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import XCTest
import CoreLocation

@testable import myToDo

class InputViewControllerTests: XCTestCase
{
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp()
    {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewControllerWithIdentifier("InputViewController") as! InputViewController
        _ = sut.view
        
    }
    

    func test_HasTitleTextField()
    {
        XCTAssertNotNil(sut.titleTextField)
    }
    
    func test_HasDateTextField()
    {
        XCTAssertNotNil(sut.dateTextField)
    }
    
    func test_HasLocationTextField()
    {
        XCTAssertNotNil(sut.locationTextField)
    }
    
    func test_HasAddressTextField()
    {
        XCTAssertNotNil(sut.addressTextField)
    }
    
    func test_HasDescriptionTextField()
    {
        XCTAssertNotNil(sut.descriptionTextField)
    }
    
    // the most important test ... go again over it! // TODO:
    func testSave_UsesGeocoderToGetCoordinatFromAddress()
    {
        sut.titleTextField.text = "Test title"
        sut.dateTextField.text = "02/22/2016"
        sut.locationTextField.text = "Office"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Test description"
        
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        
        sut.itemManager = ItemManager()
        sut.save()
        
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        
        mockGeocoder.completionHandler?([placemark],nil)
        
        let item = sut.itemManager?.itemAtIndex(0)
        
        let testItem = ToDoItem(title: "Test title", itemDescription: "Test description", timestamp: 1456095600, location: Location(name: "Office", coordinate: coordinate))
        
        XCTAssertEqual(item, testItem)
    }
    
    func test_SaveFunction_HasSaveAction()
    {
        let saveButton: UIButton = sut.saveButton
        guard let actions = saveButton.actionsForTarget(sut, forControlEvent: .TouchUpInside) else {
            XCTFail()
            return
        }
        XCTAssertTrue(actions.contains("save"))
    }
    
    func test_GeocoderWorksAsExpected()
    {
        let expectation = expectationWithDescription("Meine Erwartung")
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") { (placemarks, error) -> Void in
            print(placemarks?.first)
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {XCTFail(); return}
            guard let longitude = coordinate?.longitude else {XCTFail(); return}
            XCTAssertEqualWithAccuracy(latitude, 37.3316851, accuracy: 0.00001)
            XCTAssertEqualWithAccuracy(longitude, -122.0300674,accuracy: 0.00001)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(3.0, handler: nil)
    }
}

extension InputViewControllerTests
{
    class MockGeocoder: CLGeocoder
    {
        var completionHandler: CLGeocodeCompletionHandler?
        override func geocodeAddressString(addressString: String, completionHandler: CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark: CLPlacemark
    {
        var mockCoordinate: CLLocationCoordinate2D?
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else {return CLLocation()}
            return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}

