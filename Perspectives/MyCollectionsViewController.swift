//
//  ViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 10/31/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData

class MyCollectionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var fetchedResultsController:NSFetchedResultsController = self.collectionsfetchedResultController()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("MY_COLLECTIONS", comment: "")
    }
    
    // MARK: - NSFetchedResultsController
    
    func collectionsfetchedResultController()
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
        
        let fetchRequest = NSFetchRequest(entityName: "Collection")
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "createdDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        let collection = fetchedResultsController.objectAtIndexPath(indexPath) as! Collection
        
        if let owner = collection.owner {
            print("\(collection.name!) owner \(owner.name!)")
            cell.nameLabel.text = collection.name
            if let collectionDescription = collection.about {
                print("\(collection.name!) description \(collectionDescription)")
            }
            if let imageData = collection.image {
                cell.imageView.image! = UIImage(data: imageData)!
            }
            if let createdDate = collection.createdDate {
                
            }
        }
        else {
            print("collection \(collection.name!) has no owner")
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let collection = fetchedResultsController.objectAtIndexPath(indexPath) as! Collection
        let collectionViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CollectionViewController") as! CollectionViewController
        collectionViewController.collection = collection
        print("collection: \(collection.name!)")
        self.navigationController!.pushViewController(collectionViewController, animated: true)
    }
    
}
