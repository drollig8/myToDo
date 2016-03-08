//
//  ItemListViewController.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import UIKit

class ItemListViewController:UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    var dataProvider: protocol<UITableViewDataSource, UITableViewDelegate>!
    
    override func viewDidLoad()
    {
        dataProvider = ItemListDataProvider()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
    
    @IBAction func addItem(sender: UIBarButtonItem)
    {
    }
}
