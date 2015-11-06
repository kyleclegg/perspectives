//
//  AddCollectionViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/3/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData

class AddCollectionViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    
    @IBAction func saveCollection(sender: AnyObject) {
        
        if self.nameTextField.text!.isEmpty { return }
        
        let managedContext = CoreDataStack.sharedManager.context
        
        let entity =  NSEntityDescription.entityForName("Collection", inManagedObjectContext:managedContext)
        let collection = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Collection

        collection.name = self.nameTextField.text!
        collection.createdDate = NSDate()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userId = defaults.objectForKey(Constants.UserDefaults.userId) as? NSNumber {
            collection.createdBy = userId
        }
        
        if !self.aboutTextView.text!.isEmpty {
            collection.about = self.aboutTextView.text!
        }
        
        do {
            try managedContext.save()
            print("Successfully saved")
            navigationController?.popViewControllerAnimated(true)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
