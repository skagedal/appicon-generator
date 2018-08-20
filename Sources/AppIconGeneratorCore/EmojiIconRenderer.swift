//
//  Created by Simon Kågedal Reimer on 2018-06-09.
//

import Cocoa

public class EmojiIconRenderer: IconRenderer {
    public enum Error: Swift.Error {
        case couldNotCreateBitmapImage
        case couldNotCreatePNGRepresentation
    }

    let text: String
    let backgroundColor: NSColor
    
    public init(text: String, backgroundColor: NSColor) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
    
    public func render(sizeInPixels: Int) throws -> Data {
        guard let imageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: sizeInPixels, pixelsHigh: sizeInPixels, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0) else {
            throw Error.couldNotCreateBitmapImage
        }
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: imageRep)
        
        let string = text as NSString
        
        let width = CGFloat(sizeInPixels)
        let imageSize = NSSize(width: width, height: width)
        let font = NSFont.systemFont(ofSize: width * 0.843)
        let attributes: [NSAttributedString.Key : Any] = [.font: font]
        
        let rect = string.boundingRect(with: imageSize, options: [], attributes: attributes)
        
        backgroundColor.setFill()
        NSRect(x: 0, y: 0, width: width, height: width).fill()
        string.draw(in: NSRect(x: width / 2 - rect.width / 2,
                               y: width / 2 - rect.size.height / 2 ,
                               width: rect.width,
                               height: rect.height),
                    withAttributes: attributes)
        
        guard let data = imageRep.representation(using: .png, properties: [:]) else {
            throw Error.couldNotCreatePNGRepresentation
        }
        return data
    }
}


