//
//  KeyChainAccessible.swift
//  myToDo
//
//  Created by Marc Felden on 09.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import Foundation

protocol KeychainAccessible
{
    func setPassword(password: String, account: String)
    func deletePasswordForAccount(account: String)
    func passwordForAccount(account: String) -> String?
    
}