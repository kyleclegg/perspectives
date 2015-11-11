//
//  AddCollectionViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/3/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData

class AddCollectionViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var collection:Collection?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let incomingCollection = self.collection {
            print("incoming collection \(incomingCollection.name!)")
            self.nameTextField.text! = incomingCollection.name!
            self.descriptionTextField.text! = incomingCollection.about!
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveCollection(sender: AnyObject) {
        
        if self.nameTextField.text!.isEmpty { return }
        
        if let _ = self.collection {
            saveUpdatedCollection()
        } else {
            saveNewCollection()
        }
    }
    
    // MARK: - Convenience
    
    func saveUpdatedCollection() {
        let managedContext = CoreDataStack.sharedManager.context
        
        if let incomingCollection = self.collection {
        
            incomingCollection.name = self.nameTextField.text!
            
            if !self.descriptionTextField.text!.isEmpty {
                incomingCollection.about = self.descriptionTextField.text!
            }
            
            do {
                try managedContext.save()
                print("Successfully saved collection update")
                self.navigationController!.popViewControllerAnimated(true)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveNewCollection() {
        let managedContext = CoreDataStack.sharedManager.context
        
        let entity =  NSEntityDescription.entityForName("Collection", inManagedObjectContext:managedContext)
        let collection = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Collection
        
        collection.name = self.nameTextField.text!
        collection.createdDate = NSDate()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userId = defaults.objectForKey(Constants.UserDefaults.userId) as? NSNumber {
            
            let fetchRequest = NSFetchRequest(entityName: "User")
            fetchRequest.fetchBatchSize = 1
            fetchRequest.predicate = NSPredicate(format: "userId = %@", userId)
            do {
                let fetchResults = (try managedContext.executeFetchRequest(fetchRequest)) as? [User]
                collection.owner = fetchResults?.first
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
        
        if !self.descriptionTextField.text!.isEmpty {
            collection.about = self.descriptionTextField.text!
        }
        
        do {
            try managedContext.save()
            print("Successfully saved new collection")
            self.dismissViewControllerAnimated(true, completion: nil)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
