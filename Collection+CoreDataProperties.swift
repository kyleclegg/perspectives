//
//  Collection+CoreDataProperties.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/10/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Collection {

    @NSManaged var about: String?
    @NSManaged var collectionId: NSNumber?
    @NSManaged var createdDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var owner: User?
    @NSManaged var perspectives: NSSet?

}
