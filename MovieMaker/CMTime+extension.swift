//
//  CMTime+extension.swift
//  Togness
//
//  Created by Satish's iMac on 23/06/20.
//  Copyright © 2020 Phanha Uy. All rights reserved.
//

import Foundation
import CoreMedia

public extension CMTime {
    init(value: Int64, _ timescale: Int = 1) {
        self = CMTimeMake(value: value, timescale: Int32(timescale))
    }
    init(value: Int64, _ timescale: Int32 = 1) {
        self = CMTimeMake(value: value, timescale: timescale)
    }
    init(seconds: Float64, preferredTimeScale: Int32 = 600) {
        self = CMTimeMakeWithSeconds(seconds, preferredTimescale: preferredTimeScale)
    }
    init(seconds: Float, preferredTimeScale: Int32 = 600) {
        self = CMTime(seconds: Float64(seconds), preferredTimeScale: preferredTimeScale)
    }
    func cb_time(preferredTimeScale: Int32 = 600) -> CMTime {
        return CMTime(seconds: seconds, preferredTimescale: preferredTimeScale)
    }
}
