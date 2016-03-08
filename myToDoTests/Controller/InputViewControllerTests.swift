//
//  InputViewControllerTests.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import XCTest
import MapKit
@testable import myToDo

class InputViewControllerTests: XCTestCase
{
    var sut: InputViewController!

    
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
}

