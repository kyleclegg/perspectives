//
//  CollectionViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/10/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var collection:Collection?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.collection!.name
        self.nameLabel.text! = self.collection!.name!
        self.descriptionLabel.text! = self.collection!.about!
    }
    
    // MARK: - Segue 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "EditCollectionSegue" {
            let controller = segue.destinationViewController as! AddCollectionViewController
            controller.collection = self.collection!
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

}
