//
//  Perspective+CoreDataProperties.swift
//  
//
//  Created by Kyle Clegg on 11/30/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Perspective {

    @NSManaged var about: String?
    @NSManaged var collectionId: NSNumber?
    @NSManaged var createdDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var perspectiveId: NSNumber?
    @NSManaged var audioFilePath: String?
    @NSManaged var collection: Collection?

}
