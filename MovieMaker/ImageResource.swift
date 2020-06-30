//
//  ImageResource.swift
//  Togness
//
//  Created by Satish's iMac on 23/06/20.
//  Copyright © 2020 Phanha Uy. All rights reserved.
//

import Foundation
import CoreImage
import CoreMedia

/// Provide a Image as video frame
class ImageResource: Resource {
    
    public init(image: CIImage, duration: CMTime) {
        super.init()
        self.image = image
        self.duration = duration
        self.selectedTimeRange = CMTimeRange(start: CMTime.zero, duration: duration)
    }
    
    required public init() {
        super.init()
    }
    
    var image: CIImage? = nil
    
    override func image(at time: CMTime, renderSize: CGSize) -> CIImage? {
        return image
    }
    
}
