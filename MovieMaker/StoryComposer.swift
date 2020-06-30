//
//  StoryComposer.swift
//  Togness
//
//  Created by Canopas on 18/06/20.
//  Copyright © 2020 Phanha Uy. All rights reserved.
//

import Foundation
import AVFoundation

class StoryComposer {
    var slide:[ImageResource] = []
    
    init() {
    }
    
    private var needRebuildComposition = true
    private var needRebuildVideoComposition = true
    
    private(set) var composition: AVMutableComposition?
    private(set) var videoComposition: AVMutableVideoComposition?
    
    private(set) var addedTrackIds:[CMPersistentTrackID] = []
}
    

extension StoryComposer {
    func composeForAVPlayerItem() -> (AVPlayerItem, AVMutableComposition, AVMutableVideoComposition) {
        let composition = compose()
        let playerItem = AVPlayerItem(asset: composition)
        let video = composeVideoComposition()
        playerItem.videoComposition = video
        return (playerItem, composition, video!)
    }
}

extension StoryComposer {
    
 
    
    @discardableResult func compose() -> AVMutableComposition {
        if let oldComposition = self.composition, !needRebuildComposition {
            return oldComposition
        }
                
        let composition = AVMutableComposition(urlAssetInitializationOptions: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
        
        var startTime = CMTime(seconds: 0, preferredTimescale: 1)
        for (_, item) in slide.enumerated() {
            
            let track = slide.first!.trackInfo(for: .video, at: 0).track
            let emptyVideoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
            if let id = emptyVideoTrack?.trackID {
                addedTrackIds.append(id)
            }
            do {
                emptyVideoTrack?.removeTimeRange(CMTimeRange(start: startTime, duration: item.duration))
                try emptyVideoTrack?.insertTimeRange(CMTimeRangeMake(start: startTime, duration: CMTime(seconds: 1, preferredTimescale: 30)), of: track, at: startTime)
                emptyVideoTrack?.scaleTimeRange(CMTimeRange(start: startTime, duration: CMTime(seconds: 1, preferredTimescale: 30)), toDuration: item.duration)
            } catch {
                print("\(Self.self) : \(#function) error - \(error)")
            }
            startTime = CMTimeAdd(startTime, item.duration)
        }
        
        self.composition = composition
        return composition
    }
}

extension StoryComposer {
    public func composeVideoComposition() -> AVMutableVideoComposition? {
        if let videoComposition = self.videoComposition, !needRebuildVideoComposition {
            return videoComposition
        }
        compose()
        var videoCompositionInstruction = [VideoCompositionInstruction]()
        var startTime = CMTime(seconds: 0, preferredTimescale: 1)
        for (index, item) in slide.enumerated() {
            let trackId:CMPersistentTrackID = Int32(index) + 1
            let layerInstr = VideoCompositionLayerInstruction(trackID: trackId)
            layerInstr.resource = item
            
            let instr = VideoCompositionInstruction(theSourceTrackIDs: [layerInstr.trackID as NSValue], forTimeRange: CMTimeRangeMake(start: startTime, duration: item.duration))
            instr.layerInstructions = [layerInstr]
            videoCompositionInstruction.append(instr)
            startTime = CMTimeAdd(startTime, item.duration)
        }
        
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        videoComposition.customVideoCompositorClass = VideoCompositor.self
        videoComposition.instructions = videoCompositionInstruction
        videoComposition.renderSize = CGSize(width: 480, height: 480)
        self.videoComposition = videoComposition
        
        return videoComposition
    }
    
    
}
