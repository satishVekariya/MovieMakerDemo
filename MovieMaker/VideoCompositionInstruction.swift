//
//  VideoCompositionInstruction.swift
//  Togness
//
//  Created by Satish's iMac on 24/06/20.
//  Copyright © 2020 Phanha Uy. All rights reserved.
//

import AVFoundation
import CoreImage

open class VideoCompositionInstruction: NSObject, AVVideoCompositionInstructionProtocol {
    
    open var timeRange: CMTimeRange = CMTimeRange()
    open var enablePostProcessing: Bool = false
    open var containsTweening: Bool = false
    open var requiredSourceTrackIDs: [NSValue]?
    open var passthroughTrackID: CMPersistentTrackID = 0
    
    open var layerInstructions: [VideoCompositionLayerInstruction] = []
    
    
    public init(theSourceTrackIDs: [NSValue], forTimeRange theTimeRange: CMTimeRange) {
        super.init()
        
        requiredSourceTrackIDs = theSourceTrackIDs
        timeRange = theTimeRange
        
        passthroughTrackID = kCMPersistentTrackID_Invalid
        containsTweening = true
        enablePostProcessing = false
    }
    
    open func apply(request: AVAsynchronousVideoCompositionRequest) -> CIImage? {
        let time = request.compositionTime
        let renderSize = request.renderContext.size
        var image: CIImage?
        
        layerInstructions.forEach { (instr) in
            if let sourcePixel = request.sourceFrame(byTrackID: instr.trackID) {
                let sourceImage = instr.apply(sourceImage: CIImage.init(cvPixelBuffer: sourcePixel), at: time, renderSize: renderSize)
                if let previousImage = image {
                    image = sourceImage.composited(over: previousImage)
                } else {
                    image = sourceImage
                }
            }
        }
        
        return image
    }
}

