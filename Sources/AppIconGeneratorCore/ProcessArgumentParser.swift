//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import AppKit
import AppIconKit

public struct ProcessArguments {
    public private(set) var idioms: AppIconIdioms = []
    public private(set) var drawingCommands: [DrawingCommand] = []
    public private(set) var showHelp = false
    public private(set) var showVersion = false

    public enum Error: LocalizedError {
        case unknownGlobalOption(String)

        public var errorDescription: String? {
            switch self {
            case .unknownGlobalOption(let string):
                return "Unknown global option: \(string)"
            }
        }
    }

    public init(arguments: [String]) throws {
        try parse(arguments)
    }

    private typealias TokenIterator = IndexingIterator<ArraySlice<String>>

    private mutating func parse(_ arguments: [String]) throws {
        var parsedIdioms: AppIconIdioms = []
        var iterator = arguments.dropFirst().makeIterator()
        while let argument = iterator.next() {
            switch argument {
            case "--ipad":
                parsedIdioms = parsedIdioms.union(.iPad)
            case "--iphone":
                parsedIdioms = parsedIdioms.union(.iPhone)
            case "--help":
                showHelp = true
            case "--version":
                showVersion = true
            default:
                drawingCommands.append(try parseDrawingCommand(argument, &iterator))
            }
        }

        idioms = parsedIdioms.isEmpty ? .all : parsedIdioms
    }

    private func parseDrawingCommand(_ command: String, _ iterator: inout TokenIterator) throws -> DrawingCommand {
        return DrawingCommand.emoji(text: command)
    }
}
