//
//  APIClient.swift
//  myToDo
//
//  Created by Marc Felden on 09.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import Foundation

enum WebserviceError : ErrorType {
    case DataEmptyError
    case ResponseError
}

protocol ToDoURLSession
{
    func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
}

class APIClient
{
    var keychainManager: KeychainAccessible!
    //lazy var session = NSURLSession()  // das wäre eine neue Session
   // lazy var session: NSURLSession = NSURLSession.sharedSession()  // das ist die gesharte session
    
    lazy var session: ToDoURLSession = NSURLSession.sharedSession()  // das ist die gesharte session
    
    func loginUserWithName(username: String, password:String, completion: (error: ErrorType?) -> Void)
    {
        let allowedCharacters = NSCharacterSet(charactersInString: "/%&=?$#+-~@<>|\\*,.()[]{}^!").invertedSet
        guard let encodedUsername = username.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
            fatalError()
        }
        guard let encodedPassword = password.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) else {
            fatalError()
        }
        guard let url = NSURL(string: "https://awesometodos.com/login?username=\(encodedUsername)&password=\(encodedPassword)") else
        { fatalError() }
        
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if error != nil {
                completion(error: WebserviceError.ResponseError)
                return
            }
            
            if let theData = data {
                do {
                    let responseDict = try NSJSONSerialization.JSONObjectWithData(theData,
                        options: [])
                    
                    let token = responseDict["token"] as! String
                    self.keychainManager?.setPassword(token,
                        account: "token")
                } catch {
                    completion(error: error)
                }
            } else {
                completion(error: WebserviceError.DataEmptyError)
            }
        }
        task.resume()
        
    }
}

extension NSURLSession:ToDoURLSession
{
    // also die NSURLSessino soll nun allen scheiß zusätzlich von unserer TodoURLSesison erben!
}