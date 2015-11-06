//
//  User+CoreDataProperties.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/6/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var email: String?
    @NSManaged var password: String?
    @NSManaged var name: String?
    @NSManaged var userId: NSNumber?
    @NSManaged var collections: NSSet?

}
