//
//  VideoCompositionLayerInstruction.swift
//  Togness
//
//  Created by Satish's iMac on 24/06/20.
//  Copyright © 2020 Phanha Uy. All rights reserved.
//

import AVFoundation
import CoreImage

open class VideoCompositionLayerInstruction {
    public var timeRange: CMTimeRange = CMTimeRange.zero
    public var trackID: Int32
    var resource:Resource?
    
    public init(trackID:Int32) {
        self.trackID = trackID
    }
    
    open func apply(sourceImage: CIImage, at time: CMTime, renderSize: CGSize) -> CIImage {
        var finalImage: CIImage = {
            if let sourceImage = resource?.image(at: time, renderSize: renderSize) {
                return sourceImage
            }
            return sourceImage
        }()
        let imageSize = finalImage.extent.size
        finalImage = finalImage.transformed(by: .init(scaleX: renderSize.width / imageSize.width, y: renderSize.height/imageSize.height))
        
        return finalImage
    }
}

