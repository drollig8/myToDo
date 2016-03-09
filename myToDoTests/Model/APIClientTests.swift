//
//  APIClientTests.swift
//  myToDo
//
//  Created by Marc Felden on 09.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import XCTest
import CoreLocation

@testable import myToDo

class APIClientTests: XCTestCase
{
    var sut: APIClient!
    
    override func setUp()
    {
        super.setUp()
        sut = APIClient()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testLogin_MakesRequestWithUsernameAndPassword()
    {
        let sut = APIClient()
        let mockURLSession = MockURLSession()
        sut.session = mockURLSession
     
        let completion = {(error:ErrorType?) in}
       //geht nicht so.... let completion1 = (error: ErrorType?) -> Void
        
        sut.loginUserWithName("dasdöm", password: "%&34", completion: completion)
        XCTAssertNotNil(mockURLSession.completionHandler)
        
        guard let url = mockURLSession.url else {XCTFail(); return}
        let urlComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        XCTAssertEqual(urlComponents?.path, "/login")
        
        let allowedCharacters = NSCharacterSet(charactersInString: "/%&=?$#+-~@<>|\\*,.()[]{}^!").invertedSet
        guard let expectedUsername = "dasdöm".stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
            fatalError()
        }
        guard let expectedPassword = "%&34".stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
            fatalError()
        }
        XCTAssertEqual(urlComponents?.percentEncodedQuery,
            "username=\(expectedUsername)&password=\(expectedPassword)")
    }
    
    func testLogin_ThrowsErrorWhenJSONIsInvalid()
    {
        var theError: ErrorType?
        let completion = {(error:ErrorType?)}
    }
}

extension APIClientTests
    
    
{
    
    /* Dies überschreibt die aktuelle NSURLSession. Wir können aber auche eine ganz neue Klasse erstellen...
    dann müssen wir das protocol einfügen.
    
    class MockURLSession: NSURLSession
    {
        typealias MockURLHandler = (NSData!, NSURLResponse!, NSError) -> Void
        var completionHandler: MockURLHandler?
        var url: NSURL?
        
        override func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            return NSURLSession.sharedSession().dataTaskWithURL(url)
        }
    }
    */
    
    class MockURLSession: ToDoURLSession
    {
        typealias MockURLHandler = (NSData!, NSURLResponse!, NSError) -> Void
        var completionHandler: MockURLHandler?
        var url: NSURL?
        
        func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
            self.url = url
            self.completionHandler = completionHandler
            return NSURLSession.sharedSession().dataTaskWithURL(url)
        }
    }
    
    class MockKeychainManager: KeychainAccessible
    {
        var passwordDict = [String: String]()
        
        func setPassword(password: String, account: String)
        {
            passwordDict[account] = password
            
        }
        func deletePasswordForAccount(account: String)
        {
            passwordDict.removeValueForKey(account)
        }
        func passwordForAccount(account: String) -> String?
        {
            return passwordDict[account]
        }
        
    }
}

