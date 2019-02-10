import AppKit
import AppIconKit

public struct ProcessArguments {
    public private(set) var idioms: AppIconIdioms = []
    public private(set) var drawingCommands: [DrawingCommand] = []

    public init(arguments: [String]) throws {
        guard !arguments.isEmpty else {
            throw Error.commandsMissing
        }
        var slice = arguments[1...]

        self.idioms = try parseGlobalArguments(&slice)
        self.drawingCommands = try parseDrawingCommands(&slice)
    }

    public enum Error: LocalizedError {
        case commandsMissing
        case unknownGlobalOption(String)

        public var errorDescription: String? {
            switch self {
            case .commandsMissing:
                return "Give at least one drawing command."
            case .unknownGlobalOption(let string):
                return "Unknown global option: \(string)"
            }
        }
    }

    private func parseGlobalArguments(_ slice: inout ArraySlice<String>) throws -> AppIconIdioms {
        var idioms: AppIconIdioms = []

        while let argument = slice.first, argument.starts(with: "--") {
            slice.removeFirst()
            switch argument {
            case "--ipad":
                idioms = idioms.union([AppIconIdioms.iPad])

            case "--iphone":
                idioms = idioms.union([AppIconIdioms.iPhone])

            default:
                throw Error.unknownGlobalOption(argument)
            }
        }

        return idioms.rawValue == 0 ? AppIconIdioms.all : idioms
    }

    private func parseDrawingCommands(_ slice: inout ArraySlice<String>) throws -> [DrawingCommand] {
        guard let firstCommand = slice.popFirst() else {
            throw Error.commandsMissing
        }

        var commands: [DrawingCommand] = [try parseDrawingCommand(firstCommand, &slice)]
        while let command = slice.popFirst() {
            commands += [try parseDrawingCommand(command, &slice)]
        }
        return commands
    }

    private func parseDrawingCommand(_ command: String, _ slice: inout ArraySlice<String>) throws -> DrawingCommand {
        return DrawingCommand.emoji(text: command)
    }
}
