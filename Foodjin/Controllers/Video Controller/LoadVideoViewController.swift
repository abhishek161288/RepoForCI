//
//  LoadVideoViewController.swift
//  Trasers
//
//  Created by Suman on 07/08/18.
//  Copyright © 2018 Boopathi. All rights reserved.
//

import UIKit
import AVFoundation

class LoadVideoViewController: UIViewController {
    var player: AVPlayer?
    let app = UIApplication.shared.delegate as? AppDelegate
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
       // self.loadVideo()
        self.app?.getLocation { (value) in
            if value {
                self.app?.window?.isHidden = false
                self.app?.setRootViewController()
            }
        }
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLayer?.frame = self.view.layer.bounds
    }
    
    
    private func loadVideo() {
        let path = Bundle.main.path(forResource: "foodjinapp", ofType:"mp4") ?? ""
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.ambient)))
            
            player = AVPlayer(url: URL(fileURLWithPath: path))
            self.playerLayer = AVPlayerLayer(player: player)
            self.playerLayer?.frame = self.view.bounds
            self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.playerLayer?.zPosition = -1
            self.playerLayer?.masksToBounds = true
            self.view.layer.addSublayer(self.playerLayer!)
            player?.seek(to: CMTime.zero)
            player?.play()

        } catch {
            self.app?.getLocation { (value) in
                if value {
                    self.app?.window?.isHidden = false
                    self.app?.setRootViewController()
                }
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.app?.getLocation { (value) in
            if value {
                self.app?.window?.isHidden = false
                self.app?.setRootViewController()
            }
        }
    }
}

//extension LoadVideoViewController { //Device orientation detect
//    func deviceOrientationSetup() {
//        NotificationCenter.default.addObserver(self, selector: #selector(rotated),
//                                               name: UIDevice.orientationDidChangeNotification,
//                                               object: nil) // Notification for device orientation
//    }
//    @objc func rotated() {
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.frame
//        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        playerLayer.zPosition = -1
//        if let layer = self.view.layer.sublayers?.last {
//            layer.removeFromSuperlayer()
//            self.view.layer.addSublayer(playerLayer)
//
//        }
//    }
//}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
