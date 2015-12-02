//
//  ReviewPerspectiveViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/20/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ReviewPerspectiveViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    
    var perspective:Perspective?
    var perspectiveIsBeingEdited = false
    
    var player:AVAudioPlayer!
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        player = nil
    }
    
    // MARK: - Actions

    @IBAction func playRecording(sender: AnyObject) {
        playRecording()
    }
    
    @IBAction func savePerspective(sender: AnyObject) {
        savePerspective()
    }

    // MARK: - Convenience
    
    func playRecording() {
        var url:NSURL?
        if self.perspective != nil {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            url = NSURL(fileURLWithPath: documentsPath).URLByAppendingPathComponent(self.perspective!.audioFilePath!)
        }
        
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url!)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
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
        let isBeingEdited = !self.perspective!.objectID.temporaryID
        if (!isBeingEdited) {
            self.perspective!.createdDate = NSDate()
        }
        
        let managedContext = CoreDataStack.sharedManager.context
        do {
            try managedContext.save()
            print("Successfully saved perspective")
            if (self.perspectiveIsBeingEdited) {
                let returnViewController = (self.navigationController?.viewControllers[1])! as UIViewController
                self.navigationController?.popToViewController(returnViewController, animated: true)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - EditCollectionDelegate
    
    func editedPerspective() {
        print("yo")
//        let managedContext = CoreDataStack.sharedManager.context
//        let fetchRequest = NSFetchRequest(entityName: "Collection")
//        fetchRequest.fetchBatchSize = 1
//        fetchRequest.predicate = NSPredicate(format: "self == %@", self.collection!.objectID)
//        do {
//            let fetchResults = (try managedContext.executeFetchRequest(fetchRequest)) as? [Collection]
//            self.collection = fetchResults?.first
//        } catch let error as NSError {
//            print("Fetch failed: \(error.localizedDescription)")
//        }
//        self.populateContent()
    }

}

// MARK: - AVAudioPlayerDelegate

extension ReviewPerspectiveViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}
