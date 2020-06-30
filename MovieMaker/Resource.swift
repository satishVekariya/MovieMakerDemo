//
//  Resource.swift
//  Togness
//
//  Created by Canopas on 23/06/20.
//  Copyright © 2020 Phanha Uy. All rights reserved.
//

import Foundation
import CoreMedia
import AVFoundation
import CoreImage

class Resource: NSObject {
    /// Max duration of this resource
    open var duration: CMTime = CMTime.zero
    
    /// Selected time range, indicate how many resources will be inserted to AVCompositionTrack
    open var selectedTimeRange: CMTimeRange = CMTimeRange.zero
    
    private var _scaledDuration: CMTime = CMTime.invalid
    public var scaledDuration: CMTime {
        get {
            if !_scaledDuration.isValid {
                return selectedTimeRange.duration
            }
            return _scaledDuration
        }
        set {
            _scaledDuration = newValue
        }
    }
    
    required override init() {
        
    }
    
    open func image(at time: CMTime, renderSize: CGSize) -> CIImage? {
        return nil
    }
    
    /// Provide tracks for specific media type
    ///
    /// - Parameter type: specific media type, currently only support AVMediaTypeVideo and AVMediaTypeAudio
    /// - Returns: tracks
    open func tracks(for type: AVMediaType) -> [AVAssetTrack] {
        if let tracks = Resource.emptyAsset?.tracks(withMediaType: type) {
            return tracks
        }
        return []
    }
    
    func trackInfo(for type: AVMediaType, at index: Int) -> ResourceTrackInfo {
        let track = tracks(for: type)[index]
        let emptyDuration = CMTime(value: 1, 30)
        let emptyTimeRange = CMTimeRangeMake(start: CMTime.zero, duration: emptyDuration)
        return ResourceTrackInfo(track: track,
                                 selectedTimeRange: emptyTimeRange,
                                 scaleToDuration: scaledDuration)
    }
    
    private static let emptyAsset: AVAsset? = {
        let bundle = Bundle(for: ImageResource.self)
        if let videoURL = bundle.url(forResource: "black_empty", withExtension: "mp4") {
            return AVAsset(url: videoURL)
        }
        
        if let url = Bundle.main.url(forResource: "black_empty", withExtension: "mp4") {
            let asset = AVAsset(url: url)
            return asset
        }
        
        return nil
    }()
}


public struct ResourceTrackInfo {
    public var track: AVAssetTrack
    public var selectedTimeRange: CMTimeRange
    public var scaleToDuration: CMTime
}
