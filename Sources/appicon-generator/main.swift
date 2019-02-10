//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import AppKit
import AppIconKit
import AppIconGeneratorCore

func run(with arguments: ProcessArguments) throws {
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

do {
    let arguments = try ProcessArguments(arguments: CommandLine.arguments)
    try run(with: arguments)
} catch {
    print(error.localizedDescription)
    exit(1)
}
