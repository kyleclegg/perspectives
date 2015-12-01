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
            url = NSURL(fileURLWithPath: self.perspective!.audioFilePath!)
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
