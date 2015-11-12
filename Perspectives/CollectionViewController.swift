//
//  CollectionViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/10/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditCollectionDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var collection:Collection?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateContent()
    }
    
    func populateContent() {
        // Populate with content from collection
        if let selectedCollection = self.collection {
            self.title = selectedCollection.name
            self.nameLabel.text! = selectedCollection.name!
            if let collectionDescription = selectedCollection.about {
                self.descriptionLabel.text! = collectionDescription
            } else {
                self.descriptionLabel.text! = ""
            }
            if let imageData = selectedCollection.image {
                self.coverImageView.image! = UIImage(data: imageData)!
            }
        }
    }
    
    // MARK: - Segue 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "EditCollectionSegue" {
            let controller = segue.destinationViewController as! AddCollectionViewController
            controller.collection = self.collection!
            controller.editedCollectionDelegate = self
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collection!.perspectives!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PerspectiveCell", forIndexPath: indexPath)
//        
//        if let owner = collection.owner {
//            print("collection \(collection.name!)'s owner is \(owner.name!)")
//        }
//        else {
//            print("collection \(collection.name!) has no owner")
//        }
//        
//        cell.textLabel?.text = persepective.name
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    // MARK: - EditCollectionDelegate
    
    func editedCollection() {
        let managedContext = CoreDataStack.sharedManager.context
        let fetchRequest = NSFetchRequest(entityName: "Collection")
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "collectionId = %@", self.collection!.collectionId!)
        do {
            let fetchResults = (try managedContext.executeFetchRequest(fetchRequest)) as? [Collection]
            self.collection = fetchResults?.first
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        self.populateContent()
    }

}
