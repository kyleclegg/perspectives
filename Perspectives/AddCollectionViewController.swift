//
//  AddCollectionViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/3/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData

protocol EditCollectionDelegate {
    func editedCollection()
}

class AddCollectionViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var editedCollectionDelegate: EditCollectionDelegate?
    
    var collection:Collection?
    var photoUpdated:Bool = false
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate with content from incoming collection
        if let incomingCollection = self.collection {
            self.nameTextField.text! = incomingCollection.name!
            if let collectionDescription = collection!.about {
                self.descriptionTextField.text! = collectionDescription
            }
            if let imageData = self.collection!.image {
                self.coverImageView.image! = UIImage(data: imageData)!
            }
            
            self.title = NSLocalizedString("EDIT_COLLECTION", comment: "")
            self.navigationItem.leftBarButtonItem = nil
        } else {
            self.title = NSLocalizedString("ADD_COLLECTION", comment: "")
            self.deleteButton.hidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveCollection(sender: AnyObject) {
        if self.nameTextField.text!.isEmpty { return }
        
        if let _ = self.collection {
            saveEditedCollection()
        } else {
            saveNewCollection()
        }
    }
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        // Setup alert controller
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString("UPLOAD_PHOTO", comment: ""), message: "", preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .Cancel) { action -> Void in
            // Do nothing
            
        }
        alertController.addAction(cancelAction)
        
        // Add camera option
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let takePhotoAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("TAKE_PHOTO", comment: ""), style: .Default) { action -> Void in
                self.takePhoto()
            }
            alertController.addAction(takePhotoAction)
        }
        
        // Add library option
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let choosePhotoAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("PHOTO_LIBRARY", comment: ""), style: .Default) { action -> Void in
                self.selectPhotoFromLibrary()
            }
            alertController.addAction(choosePhotoAction)
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteCollection(sender: AnyObject) {
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString("DELETE_COLLECTION_DETAILS", comment: ""), message: "", preferredStyle: .ActionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .Cancel) { action -> Void in
            // Do nothing
        }
        alertController.addAction(cancelAction)
        
        let deleteAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("DELETE_COLLECTION", comment: ""), style: .Destructive) { action -> Void in
            self.deleteCollection()
        }
        alertController.addAction(deleteAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - Convenience
    
    func saveEditedCollection() {
        if let incomingCollection = self.collection {
        
            incomingCollection.name = self.nameTextField.text!
            
            if !self.descriptionTextField.text!.isEmpty {
                incomingCollection.about = self.descriptionTextField.text!
            }
            if self.photoUpdated == true {
                if let selectedImage = self.coverImageView.image {
                    incomingCollection.image = NSData(data: UIImagePNGRepresentation(selectedImage)!)
                }
            }
            
            let managedContext = CoreDataStack.sharedManager.context
            do {
                try managedContext.save()
                print("Successfully saved collection update")
                self.navigationController!.popViewControllerAnimated(true)
                if let delegate = self.editedCollectionDelegate {
                    delegate.editedCollection()
                }
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveNewCollection() {
        let managedContext = CoreDataStack.sharedManager.context
        let entity =  NSEntityDescription.entityForName("Collection", inManagedObjectContext:managedContext)
        let collection = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Collection
        
        collection.name = self.nameTextField.text!
        collection.createdDate = NSDate()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let userId = defaults.objectForKey(Constants.UserDefaults.userId) as? NSNumber {
            
            let fetchRequest = NSFetchRequest(entityName: "User")
            fetchRequest.fetchBatchSize = 1
            fetchRequest.predicate = NSPredicate(format: "userId = %@", userId)
            do {
                let fetchResults = (try managedContext.executeFetchRequest(fetchRequest)) as? [User]
                collection.owner = fetchResults?.first
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
        
        if !self.descriptionTextField.text!.isEmpty {
            collection.about = self.descriptionTextField.text!
        }
        if self.photoUpdated == true {
            if let selectedImage = self.coverImageView.image {
                collection.image = NSData(data: UIImagePNGRepresentation(selectedImage)!)
            }
        }
        
        do {
            try managedContext.save()
            print("Successfully saved new collection")
            self.dismissViewControllerAnimated(true, completion: nil)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func takePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func selectPhotoFromLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func deleteCollection() {
        if let collection = self.collection {
            let managedContext = CoreDataStack.sharedManager.context
            managedContext.deleteObject(collection)
            do {
                try managedContext.save()
                print("Deleted collection")
                self.navigationController?.popToRootViewControllerAnimated(true)
            } catch let error as NSError  {
                print("Could not delete \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var selectedImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = possibleImage
        } else {
            return
        }
        
        let resizedImage = selectedImage.resizeImageWithAspectFit(selectedImage, size: CGSizeMake(1200, 1200))
        self.coverImageView.image = resizedImage
        print("original size: \(selectedImage.size)")
        print("resized size: \(resizedImage.size)")
        self.photoUpdated = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
