//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import Cocoa

/// A class to render emoji icons.
public class EmojiIconRenderer: IconRenderer {
    /// Errors thrown by `EmojiIconRenderer`.
    public enum Error: Swift.Error {
        /// Creation of bitmap failed for some reason.
        case couldNotCreateBitmapImage
        /// Creation of graphics context failed for some reason.
        case couldNotCreateGraphicsContext
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
        guard let imageRep = NSBitmapImageRep(standardSquareBitmapWith: sizeInPixels) else {
            throw Error.couldNotCreateBitmapImage
        }
        guard let graphicsContext = NSGraphicsContext(bitmapImageRep: imageRep) else {
            throw Error.couldNotCreateGraphicsContext
        }
        NSGraphicsContext.current = graphicsContext

        render(in: graphicsContext)

        guard let data = imageRep.representation(using: .png, properties: [:]) else {
            throw Error.couldNotCreatePNGRepresentation
        }
        return data
    }

    private func render(in context: NSGraphicsContext) {
        let cgContext = context.cgContext
        let string = text as NSString

        let width = CGFloat(cgContext.width)
        let height = CGFloat(cgContext.height)
        let imageSize = NSSize(width: width, height: height)
        let font = NSFont.systemFont(ofSize: width * 0.843)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]

        let rect = string.boundingRect(with: imageSize, options: [], attributes: attributes)

        backgroundColor.setFill()
        NSRect(x: 0, y: 0, width: width, height: width).fill()
        string.draw(in: NSRect(x: width / 2 - rect.width / 2,
                               y: width / 2 - rect.size.height / 2 ,
                               width: rect.width,
                               height: rect.height),
                    withAttributes: attributes)
    }
}
