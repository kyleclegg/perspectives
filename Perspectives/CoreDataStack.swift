//
//  CoreDataManager.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/3/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: Properties
    
    static let sharedManager = CoreDataStack()
    static let applicationDocumentsDirectoryName = "com.kyleclegg.Perspectives"
    static let mainStoreFileName = "Perspectives.storedata"
    static let errorDomain = "CoreDataStack"
    
    // The managed object model for the application
    lazy var managedObjectModel: NSManagedObjectModel = {
        /*
        This property is not optional. It is a fatal error for the application
        not to be able to find and load its model.
        */
        let modelURL = NSBundle.mainBundle().URLForResource("Perspectives", withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    // Primary persistent store coordinator for the application
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        /*
        This implementation creates and return a coordinator, having added the
        store for the application to it. (The directory for the store is created, if necessary.)
        */
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: self.storeURL, options: options)
        }
        catch {
            fatalError("Could not add the persistent store: \(error).")
        }
        
        return persistentStoreCoordinator
    }()
    
    // The directory the application uses to store the Core Data store file
    lazy var applicationDocumentsDirectory: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        
        let urls = fileManager.URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        let applicationSupportDirectoryURL = urls.last!
        let applicationSupportDirectory = applicationSupportDirectoryURL.URLByAppendingPathComponent(applicationDocumentsDirectoryName)
        
        do {
            let properties = try applicationSupportDirectory.resourceValuesForKeys([NSURLIsDirectoryKey])
            if let isDirectory = properties[NSURLIsDirectoryKey] as? Bool where isDirectory == false {
                let description = NSLocalizedString("Could not access the application data folder.", comment: "Failed to initialize applicationSupportDirectory.")
                
                let reason = NSLocalizedString("Found a file in its place.", comment: "Failed to initialize applicationSupportDirectory.")
                
                throw NSError(domain: errorDomain, code: 201, userInfo: [
                    NSLocalizedDescriptionKey: description,
                    NSLocalizedFailureReasonErrorKey: reason
                    ])
            }
        }
        catch let error as NSError where error.code != NSFileReadNoSuchFileError {
            fatalError("Error occured: \(error).")
        }
        catch {
            let path = applicationSupportDirectory.path!
            
            do {
                try fileManager.createDirectoryAtPath(path, withIntermediateDirectories:true, attributes:nil)
            }
            catch {
                fatalError("Could not create application documents directory at \(path).")
            }
        }
        
        return applicationSupportDirectory
    }()
    
    // URL for the main Core Data store file
    lazy var storeURL: NSURL = {
        return self.applicationDocumentsDirectory.URLByAppendingPathComponent(mainStoreFileName)
    }()

    // Managed object context for the application (which is already bound to the persistent store coordinator for the application)
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error: \(nserror.localizedDescription)")
                abort()
            }
        }
    }
}