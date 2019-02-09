//
//  Created by Simon Kågedal Reimer on 2018-08-22.
//

import Cocoa

extension NSBitmapImageRep {
    convenience init?(standardSquareBitmapWith pixelSize: Int) {
        self.init(bitmapDataPlanes: nil,
                  pixelsWide: pixelSize,
                  pixelsHigh: pixelSize,
                  bitsPerSample: 8,
                  samplesPerPixel: 4,
                  hasAlpha: true,
                  isPlanar: false,
                  colorSpaceName: .calibratedRGB,
                  bytesPerRow: 0,
                  bitsPerPixel: 0)
    }
}
