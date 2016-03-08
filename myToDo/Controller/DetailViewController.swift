//
//  DetailViewController.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController
{
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var locationLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var mapView:MKMapView!
    
    @IBAction func checkItemButton(sender: AnyObject)
    {
        itemInfo!.0.checkItemAtIndex(itemInfo!.1)
        
    }
    var itemInfo:(ItemManager,Int)?
    
    override func viewDidAppear(animated: Bool) {
        let item = itemInfo!.0.itemAtIndex(itemInfo!.1)
        titleLabel.text = item.title
        if let timestamp = item.timestamp {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateLabel.text = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: timestamp))
        }
        descriptionLabel.text = item.description
        locationLabel.text = item.location?.name
        if let coordinate = item.location?.coordinate {
            //untested
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 100, 100)
            mapView.region = region
        }
    }
}
