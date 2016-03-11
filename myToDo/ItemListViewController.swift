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
    
    // TODO statt dem Protocol Kram kann man einfach auch DataProvider scheiben.
    var dataProvider: protocol<UITableViewDataSource, UITableViewDelegate, ItemManagerSettable>!
    
    var itemManager = ItemManager()
    
    override func viewDidLoad()
    {
        dataProvider = ItemListDataProvider()
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showDetails:", name: kItemSelectedNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addItem(sender: UIBarButtonItem)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("InputViewController") as! InputViewController
        viewController.itemManager = self.itemManager
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func showDetails(sender:NSNotification) {
        guard let index = sender.userInfo?["index"] as? Int else {fatalError()}
        if let nextViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }}
}
