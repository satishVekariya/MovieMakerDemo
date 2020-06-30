//
//  ViewController.swift
//  MovieMaker
//
//  Created by Satish's iMac on 30/06/20.
//  Copyright © 2020 Canopas Inc. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let items =
                    [UIImage(named: "emptyStoryIcon")!,
                     UIImage(named: "featureIcon")!,
                     UIImage(named: "errorSad")!]
                    .compactMap { $0.cgImage }
                        .map { ImageResource(image: .init(cgImage: $0), duration: .init(seconds: 5.0)) }
                
                
                let composer = StoryComposer()
                composer.slide = items
        
        let playerItem = composer.composeForAVPlayerItem()
                
                
        let player = AVPlayer(playerItem: playerItem.0)
        
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.present(playerVC, animated: true, completion: nil)
        }
    }
    
    


}

