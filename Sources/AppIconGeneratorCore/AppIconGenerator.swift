//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import AppKit
import AppIconKit

public struct AppIconGenerator {
    private let arguments: [String]

    public enum Error: LocalizedError {
        case commandsMissing

        public var errorDescription: String? {
            switch self {
            case .commandsMissing:
                return "Give at least one drawing command."
            }
        }
    }

    public init(arguments: [String]) {
        self.arguments = arguments
    }

    public func run() -> Int32 {
        do {
            let arguments = try ProcessArguments(arguments: self.arguments)
            try run(with: arguments)
        } catch {
            print(error.localizedDescription)
            return 1
        }
        return 0
    }

    private func run(with arguments: ProcessArguments) throws {
        guard !arguments.drawingCommands.isEmpty else {
            throw Error.commandsMissing
        }

        let text = arguments.drawingCommands.compactMap({ command -> String? in
            if case let DrawingCommand.emoji(text: text) = command {
                return text
            } else {
                return nil
            }
        })[0]

        let renderer = EmojiIconRenderer(text: text, backgroundColor: .white)
        let generator = AppIconSetGenerator(iconRenderer: renderer)
        let currentDirectory = URL(fileURLWithPath: "")
        let chosenDirectory = try FileManager.default.findAssets(in: currentDirectory) ?? currentDirectory
        let appIconSetDirectory = try generator.createAppIconSet(in: chosenDirectory, for: arguments.idioms)
        print("Icon set generated: \(appIconSetDirectory.relativePath)")
    }
}
