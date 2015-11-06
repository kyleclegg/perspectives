//
//  SignInViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/5/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData

class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    
    @IBAction func signInPressed(sender: AnyObject) {
        createUser()
    }
    
    // MARK: Convenience
    
    private func createUser() {
        let managedContext = CoreDataStack.sharedManager.context
        
        let entity =  NSEntityDescription.entityForName("User", inManagedObjectContext:managedContext)
        let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! User
        
        user.userId = 1
        user.name = "Lola"
        user.email = "lola.clegg@gmail.com"
        user.password = "sweetlolagirl174"
        
        do {
            try managedContext.save()
            print("User created")
            dismissSignIn()
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: Constants.UserDefaults.loggedIn)
            defaults.setObject(user.userId, forKey: Constants.UserDefaults.userId)
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    private func dismissSignIn() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryboard.instantiateViewControllerWithIdentifier("RootNavigationController")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = controller
        appDelegate.window?.makeKeyAndVisible()
    }
    
}
