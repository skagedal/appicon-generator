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

/// Something that renders a single icon.
public protocol IconRenderer {
    /// Conform to this and render an icon.  Give it to an `AppIconSetGenerator` to generate a full set
    /// of icons.
    ///
    /// - Parameter sizeInPixels: The width/height in pixels.  Icons are quadratic.
    /// - Returns: An icon rendered as PNG.
    /// - Throws: Any error. 
    func renderPNG(sizeInPixels: Int) throws -> Data
}

public struct AppIconIdioms: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let iPhone = AppIconIdioms(rawValue: 1 << 0)
    public static let iPad = AppIconIdioms(rawValue: 1 << 1)
    public static let all: AppIconIdioms = [.iPhone, iPad]
}

internal extension StoredAppIconIdiom {
    func matches(_ idioms: AppIconIdioms) -> Bool {
        switch self {
        case .ipad:
            return idioms.contains(.iPad)
        case .iphone:
            return idioms.contains(.iPhone)
        case .iosMarketing:
            return true
        }
    }
}

/// Use `AppIconSetGenerator` to generate a complete set of app icons, including the Contents.json
/// file, given and `IconRenderer`.
///
/// Try using it with an `EmojiIconRenderer`. 
public class AppIconSetGenerator {
    private let iconRenderer: IconRenderer
    private let fileManager: FileManager = FileManager.default

    /// - Parameter iconRenderer: The object responsible for rendering individual icons.
    public init(iconRenderer: IconRenderer) {
        self.iconRenderer = iconRenderer
    }

    /// Create an app icon set.  Any existing files `AppIcon.appiconset` at the given location will be overwritten.
    /// However, unreferenced image files might be left around – so you might want to just check for any existing
    /// `AppIcon.appiconset` and delete it first if that's what you want.
    ///
    /// - Parameters:
    ///   - directory: The `AppIcon.appiconset` will be placed here.
    ///   - idioms: Generate icons for iPhone, iPad or both? Defaults to both. That is, `all`.
    /// - Returns: The URL of the created `AppIcon.appiconset`.
    /// - Throws: Any file management errors or rethrown errors from your `IconRenderer`.
    @discardableResult
    public func createAppIconSet(in directory: URL, for idioms: AppIconIdioms = .all) throws -> URL {
        let iconsetDirectory = try createdIconSetDirectory(at: directory.appendingPathComponent("AppIcon.appiconset"))
        let baseFilename = "icon"
        let variants = allVariants.filter { $0.idiom.matches(idioms) }
        let contentsJsonURL = iconsetDirectory.appendingPathComponent("Contents.json")
        try writeContentsJson(from: variants, baseFilename: baseFilename, to: contentsJsonURL)
        try writeUniqueIcons(from: variants, baseFilename: baseFilename, in: iconsetDirectory)
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
            let data = try iconRenderer.renderPNG(sizeInPixels: pixels)
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(variant.sizeInPixels)
    }
}
