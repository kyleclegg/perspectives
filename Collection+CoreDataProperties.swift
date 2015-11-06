//
//  Collection+CoreDataProperties.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/5/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Collection {

    @NSManaged var name: String?
    @NSManaged var createdDate: NSDate?
    @NSManaged var about: String?
    @NSManaged var collectionId: NSNumber?
    @NSManaged var createdBy: NSNumber?

}