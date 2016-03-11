//
//  InputViewController.swift
//  myToDo
//
//  Created by Marc Felden on 08.03.16.
//  Copyright © 2016 Timm Kent. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController
{
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    lazy var geocoder = CLGeocoder()  // dependency injection applies
    
    var itemManager: ItemManager?
    
    lazy var dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    @IBAction func save()
    {
        guard let titleString = titleTextField.text where titleString.characters.count > 0 else {return}
        
        let date: NSDate?
        
        if let dateString = dateTextField.text where dateString.characters.count > 0 {
            date = dateFormatter.dateFromString(dateString)
        } else {
            date = nil
        }
        
        let descriptionString: String?
        
        if descriptionTextField.text?.characters.count > 0 {
            descriptionString = descriptionTextField.text
        } else {
            descriptionString = nil
        }
        
        if let locationName = locationTextField.text where locationName.characters.count > 0 {
            if let address = addressTextField.text where address.characters.count > 0 {
                
                geocoder.geocodeAddressString(address, completionHandler: { [unowned self](placemarks, error) -> Void in
                    let placemark = placemarks?.first
                    
                    let item = ToDoItem(title: titleString, itemDescription: descriptionString, timestamp: date?.timeIntervalSince1970, location: Location(name: locationName, coordinate: placemark?.location?.coordinate))
                    self.itemManager?.addItem(item)
                    
                })
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
