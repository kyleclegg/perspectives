//
//  CollectionViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/10/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData

class CollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditCollectionDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var collection:Collection?
    lazy var fetchedResultsController:NSFetchedResultsController = self.perspectivesFetchedResultController()
    
    let addRowHeight:CGFloat = 60.0
    let defaultRowHeight:CGFloat = 80.0
    
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
        guard let segueIdentifier = segue.identifier else {
            return
        }
        if segueIdentifier == "EditCollectionSegue" {
            let controller = segue.destinationViewController as! AddCollectionViewController
            controller.collection = self.collection!
            controller.editedCollectionDelegate = self
        } else if segueIdentifier == "AddPerspectiveSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.viewControllers.first as! AddPerspectiveViewController
            controller.collection = self.collection!
        }
    }
    
    // MARK: - NSFetchedResultsController
    
    func perspectivesFetchedResultController()
        -> NSFetchedResultsController {
            
            fetchedResultsController =
                NSFetchedResultsController(
                    fetchRequest: collectionsFetchRequest(),
                    managedObjectContext: CoreDataStack.sharedManager.context,
                    sectionNameKeyPath: nil,
                    cacheName: nil)
            fetchedResultsController.delegate = self
            
            do {
                try fetchedResultsController.performFetch()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                abort()
            }
            
            return fetchedResultsController
    }
    
    func collectionsFetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Perspective")
        fetchRequest.fetchBatchSize = 20
        fetchRequest.predicate = NSPredicate(format: "self.collection == %@", self.collection!.objectID)
        
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2    // add new perspective and perspectives list
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1    // add new perspective row
        }
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section - 1]    // offset for the add new perspective section
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return tableView.dequeueReusableCellWithIdentifier("AddPerspectiveCell", forIndexPath: indexPath)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PerspectiveCell", forIndexPath: indexPath) as! PerspectiveCell
        let offsetIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section - 1)     // offset for the add new perspective section
        let perspective = fetchedResultsController.objectAtIndexPath(offsetIndexPath) as! Perspective
        
        cell.nameLabel.text = perspective.name
        cell.descriptionLabel.text = perspective.about
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return addRowHeight
        }
        return defaultRowHeight
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.section == 0 {
            self.performSegueWithIdentifier("AddPerspectiveSegue", sender: self)
        } else {
            let offsetIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section - 1)     // offset for the add new perspective section
            let perspective = fetchedResultsController.objectAtIndexPath(offsetIndexPath) as! Perspective
            let reviewPerspectiveViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ReviewPerspectiveViewController") as! ReviewPerspectiveViewController
            reviewPerspectiveViewController.perspective = perspective
            self.navigationController!.pushViewController(reviewPerspectiveViewController, animated: true)
        }
    }
    
    // MARK: - EditCollectionDelegate
    
    func editedCollection() {
        let managedContext = CoreDataStack.sharedManager.context
        let fetchRequest = NSFetchRequest(entityName: "Collection")
        fetchRequest.fetchBatchSize = 1
        fetchRequest.predicate = NSPredicate(format: "self == %@", self.collection!.objectID)
        do {
            let fetchResults = (try managedContext.executeFetchRequest(fetchRequest)) as? [Collection]
            self.collection = fetchResults?.first
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        self.populateContent()
    }

}
