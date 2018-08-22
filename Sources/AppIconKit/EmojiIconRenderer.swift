//
//  Created by Simon Kågedal Reimer on 2018-06-09.
//

import Cocoa

/// A class to render emoji icons.
public class EmojiIconRenderer: IconRenderer {
    /// Errors thrown by `EmojiIconRenderer`.
    public enum Error: Swift.Error {
        /// Creation of bitmap failed for some reason.
        case couldNotCreateBitmapImage
        /// Rendering into PNG failed for some reason.
        case couldNotCreatePNGRepresentation
    }

    /// Text to render.
    let text: String
    /// Background color to render.
    let backgroundColor: NSColor
    
    /// Create an Emoji icon renderer.
    ///
    /// - Parameters:
    ///   - text: May actually be any string, but a single emoji will work best.
    ///   - backgroundColor: Color to fill the background of the icon.
    public init(text: String, backgroundColor: NSColor) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
    
    /// Renders the specified emoji icon.
    ///
    /// - Parameter sizeInPixels: Width/height.
    /// - Returns: PNG.
    /// - Throws: May throw one of the `EmojiIconRenderer.Error` errors. 
    public func renderPNG(sizeInPixels: Int) throws -> Data {
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

