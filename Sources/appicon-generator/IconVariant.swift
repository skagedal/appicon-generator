//
//  Created by Simon Kågedal Reimer on 2018-08-18.
//

import Foundation

struct IconVariant {
    let idiom: AppIconIdiom
    let sizeInPoints: String
    let scale: AppIconScale
}

enum AppIconIdiom: String, Codable {
    case iphone = "iphone"
    case ipad = "ipad"
    case iosMarketing = "ios-marketing"
}

enum AppIconScale: String, Encodable {
    case oneX = "1x"
    case twoX = "2x"
    case threeX = "3x"
}

extension AppIconScale {
    var number: CGFloat {
        switch self {
        case .oneX:
            return 1
        case .twoX:
            return 2
        case .threeX:
            return 3
        }
    }
}

extension IconVariant {
    var sizeInPixels: Int {
        // Ugh.
        return Int(round(scale.number * CGFloat(Double(sizeInPoints)!)))
    }
}

// MARK: - Contents.json specific

struct AppIconSetImage: Encodable {
    let size: String
    let idiom: AppIconIdiom
    let filename: String
    let scale: AppIconScale
}

struct AppIconSetInfo: Encodable {
    let version: Int = 1
    let author: String = "appicon-generator"
}

struct AppIconSet: Encodable {
    let images: [AppIconSetImage]
    let info: AppIconSetInfo
}

extension AppIconSet {
    init(baseFilename: String, variants: [IconVariant]) {
        self = AppIconSet(images: variants.map({ variant in
            let points = "\(variant.sizeInPoints)"
            
            return AppIconSetImage(size: "\(points)x\(points)",
                                   idiom: variant.idiom,
                                   filename: "\(baseFilename)-\(variant.sizeInPixels)", scale: variant.scale)
        }), info: AppIconSetInfo())
    }
}
