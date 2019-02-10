import Foundation

extension FileManager {
    func findAssets(in url: URL, descendLevels: Int = 1) throws -> URL? {
        let children = try contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey], options: [])
        for url in children where url.isDirectory {
            if url.lastPathComponent == "Assets.xcassets" {
                return url
            } else {
                if descendLevels > 0, let subUrl = try findAssets(in: url, descendLevels: descendLevels - 1) {
                    return subUrl
                }
            }
        }
        return nil
    }
}

extension URL {
    var isDirectory: Bool {
        if #available(OSX 10.11, *) {
            return hasDirectoryPath
        } else {
            return absoluteString.last == "/"
        }
    }
}
