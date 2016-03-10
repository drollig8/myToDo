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
    var mockURLSession: MockURLSession!
    
    override func setUp()
    {
        super.setUp()
        sut = APIClient()
        mockURLSession = MockURLSession()
        sut.session = mockURLSession
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    func testLogin_MakesRequestWithUsernameAndPassword()
    {
        
     
     
        let completion = {(error:ErrorType?) in}
       //geht nicht so.... let completion1 = (error: ErrorType?) -> Void
        
        sut.loginUserWithName("dasdöm", password: "%&34", completion: completion)
        XCTAssertNotNil(mockURLSession.returnedCompletionHandler)
        
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
        let completion = {(error:ErrorType?) in
            theError = error
        }
        sut.loginUserWithName("dasdom", password: "1234", completion: completion)
        let responseData = NSData()

        
        mockURLSession.returnedCompletionHandler?(responseData,nil,nil)
        XCTAssertNotNil(theError)
    }
    
    func testLogin_ThrowsErrorWhenDataIsNil()
    {
        var theError: ErrorType?
        
        
        let completion = {(error: ErrorType?) in theError = error} // === func completion(error: ErrorType?) { theError = error }
        
        sut.loginUserWithName("dasDom", password: "1234", completion: completion)
        
        // rufe die funktion auf.
        mockURLSession.anmerkung? = "TestAnmerkung"
        
        // der CompletionHandler braucht eine Funktion : (NSData!, NSURLResponse!, NSError) -> Void
        
        // diese Zeile verstehe ich nicht.
        mockURLSession.returnedCompletionHandler?(nil,nil,nil)
        
        XCTAssertNotNil(theError)
    }
    
    func testLogin_ThrowsErrorWhenResponseHassError()
    {
        var theError: ErrorType?
        let completion = {(error: ErrorType?) in theError = error}
        sut.loginUserWithName("dasDom", password: "1234", completion: completion)
        
        let responseDict = ["token":"1234567890"]
        let reponseData = try!NSJSONSerialization.dataWithJSONObject(responseDict, options: [])
         // THIS WE TEST
        let error = NSError(domain: "SomeError", code: 1234, userInfo: nil)
        
        
        mockURLSession.returnedCompletionHandler?(reponseData,nil,error)
        
        XCTAssertNotNil(theError)
    }
}


extension APIClientTests
{
    
    // We use dependency injection to catch the completion handler of the session data rask in our fake URL session. This way, we could feed test data into the implementation code and assert that the code is implemented as expected. As we controlled the data that the completion handler received, we were able to simulate all kinds of errors and drive the implementation of the correct error handling.
    
    class MockURLSession: ToDoURLSession
    {
        typealias MockURLHandler = (NSData!, NSURLResponse!, NSError!) -> Void
        var anmerkung: String?
        
        // ein MOCK lässt uns einen Wert auslesen. (siehe auch: MockTableView, wo wir CellGotDequeued auslesen können)
        var returnedCompletionHandler: MockURLHandler?
        var url: NSURL?
        
        func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
            self.url = url
            self.returnedCompletionHandler = completionHandler
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

