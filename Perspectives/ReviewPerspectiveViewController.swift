//
//  ReviewPerspectiveViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/20/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData

class ReviewPerspectiveViewController: UIViewController {
    
    var perspective:Perspective?
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions

    @IBAction func savePerspective(sender: AnyObject) {
        savePerspective()
    }
    
    // MARK: - Convenience
    
    func savePerspective() {
        
//        guard let name = self.perspective!.name else {
//            return
//        }
//        guard let about = self.perspective!.about else {
//            return
//        }
//        guard let collection = self.perspective!.collection else {
//            return
//        }
//        guard let collectionId = self.perspective!.collection!.collectionId else {
//            return
//        }
        
        // Final setup
        self.perspective!.createdDate = NSDate()
        
        let managedContext = CoreDataStack.sharedManager.context
        do {
            try managedContext.save()
            print("Successfully saved new perspective")
            self.dismissViewControllerAnimated(true, completion: nil)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

}
