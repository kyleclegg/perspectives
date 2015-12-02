//
//  ViewPerspectiveViewController.swift
//  Perspectives
//
//  Created by Kyle Clegg on 12/1/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit
import AVFoundation

class ViewPerspectiveViewController: UIViewController {

    var perspective:Perspective?
    
    var player:AVAudioPlayer!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    
    @IBAction func playRecording(sender: AnyObject) {
        playRecording()
    }
    
    @IBAction func editPerspective(sender: AnyObject) {
        let editPerspectiveViewController = self.storyboard!.instantiateViewControllerWithIdentifier("AddPerspectiveViewController") as! AddPerspectiveViewController
        editPerspectiveViewController.collection = self.perspective!.collection!
        editPerspectiveViewController.perspective = self.perspective!
        self.navigationController!.pushViewController(editPerspectiveViewController, animated: true)
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

}

// MARK: - AVAudioPlayerDelegate

extension ViewPerspectiveViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}
