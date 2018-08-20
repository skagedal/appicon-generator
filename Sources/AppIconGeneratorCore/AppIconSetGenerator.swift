//
//  Created by Simon Kågedal Reimer on 2018-06-10.
//

import Foundation

private let allVariants: [IconVariant] = [
    IconVariant(idiom: .iphone, sizeInPoints: "20", scale: .twoX),
    IconVariant(idiom: .iphone, sizeInPoints: "20", scale: .threeX),
    IconVariant(idiom: .iphone, sizeInPoints: "29", scale: .twoX),
    IconVariant(idiom: .iphone, sizeInPoints: "29", scale: .threeX),
    IconVariant(idiom: .iphone, sizeInPoints: "40", scale: .twoX),
    IconVariant(idiom: .iphone, sizeInPoints: "40", scale: .threeX),
    IconVariant(idiom: .iphone, sizeInPoints: "60", scale: .twoX),
    IconVariant(idiom: .iphone, sizeInPoints: "60", scale: .threeX),
    IconVariant(idiom: .ipad, sizeInPoints: "20", scale: .oneX),
    IconVariant(idiom: .ipad, sizeInPoints: "20", scale: .twoX),
    IconVariant(idiom: .ipad, sizeInPoints: "29", scale: .oneX),
    IconVariant(idiom: .ipad, sizeInPoints: "29", scale: .twoX),
    IconVariant(idiom: .ipad, sizeInPoints: "40", scale: .oneX),
    IconVariant(idiom: .ipad, sizeInPoints: "40", scale: .twoX),
    IconVariant(idiom: .ipad, sizeInPoints: "76", scale: .oneX),
    IconVariant(idiom: .ipad, sizeInPoints: "76", scale: .twoX),
    IconVariant(idiom: .ipad, sizeInPoints: "83.5", scale: .twoX),
    IconVariant(idiom: .iosMarketing, sizeInPoints: "1024", scale: .oneX)
]

public protocol IconRenderer {
    func render(sizeInPixels: Int) throws -> Data
}

public class AppIconSetGenerator {
    private let iconRenderer: IconRenderer
    private let fileManager: FileManager = FileManager.default
    
    public init(iconRenderer: IconRenderer) {
        self.iconRenderer = iconRenderer
    }
    
    public func createAppIconSet(in directory: URL) throws -> URL {
        let iconsetDirectory = try createdIconSetDirectory(at: directory.appendingPathComponent("AppIcon.appiconset"))
        let baseFilename = "icon"
        try writeContentsJson(from: allVariants, baseFilename: baseFilename, to: iconsetDirectory.appendingPathComponent("Contents.json"))
        try writeUniqueIcons(from: allVariants, baseFilename: baseFilename, in: iconsetDirectory)
        return iconsetDirectory
    }
    
    private func createdIconSetDirectory(at directory: URL) throws -> URL {
        do {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: false, attributes: [:])
        } catch CocoaError.fileWriteFileExists {
            // Ignore
        }
        return directory
    }
    
    private func writeContentsJson(from variants: [IconVariant], baseFilename: String, to url: URL) throws {
        let appIconSet = AppIconSet(baseFilename: baseFilename, variants: variants)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(appIconSet)
        try data.write(to: url)
    }
    
    private func writeUniqueIcons(from variants: [IconVariant], baseFilename: String, in directory: URL) throws {
        let uniqueIcons = Set(variants.map(PixelSizeUniqueIconVariant.init(variant:)))
        for icon in uniqueIcons {
            let pixels = icon.variant.sizeInPixels
            let data = try iconRenderer.render(sizeInPixels: pixels)
            let url = directory.appendingPathComponent(icon.variant.filename(base: baseFilename))
            try data.write(to: url)
        }
    }
}

private struct PixelSizeUniqueIconVariant: Equatable, Hashable {
    let variant: IconVariant

    static func == (lhs: PixelSizeUniqueIconVariant, rhs: PixelSizeUniqueIconVariant) -> Bool {
        return lhs.variant.sizeInPixels == rhs.variant.sizeInPixels
    }
    
    var hashValue: Int {
        return variant.sizeInPixels.hashValue
    }
}
