//
//  Created by Simon Kågedal Reimer on 2018-06-10.
//

import Foundation

private let variants: [IconVariant] = [
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

class AppIconSetGenerator {
    let iconRenderer: IconRenderer
    let fileManager: FileManager
    
    init(iconRenderer: IconRenderer, fileManager: FileManager = FileManager.default) {
        self.iconRenderer = iconRenderer
        self.fileManager = fileManager
    }
    
    func createAppIconSet(in directory: URL) throws {
        let iconsetDirectory = try createdIconSetDirectory(at: directory.appendingPathComponent("AppIcon.appiconset"))
        try writeContentsJson(to: iconsetDirectory.appendingPathComponent("Contents.json"))
    }
    
    func createdIconSetDirectory(at directory: URL) throws -> URL {
        do {
            try fileManager.createDirectory(at: directory, withIntermediateDirectories: false, attributes: [:])
        } catch CocoaError.fileWriteFileExists {
            // Ignore
        }
        return directory
    }
    
    func writeContentsJson(to url: URL) throws {
        let appIconSet = AppIconSet(baseFilename: "icon", variants: variants)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(appIconSet)
        try data.write(to: url)
    }
}
