import AppKit
import AppIconGeneratorCore

guard let text = ProcessInfo.processInfo.arguments.dropFirst().first else {
    print("Please call with the text for the icon as an argument")
    exit(1)
}

let renderer = EmojiIconRenderer(text: text, backgroundColor: .white)
let generator = AppIconSetGenerator(iconRenderer: renderer)
let currentDirectory = URL(fileURLWithPath: "")
let chosenDirectory = try FileManager.default.findAssets(in: currentDirectory) ?? currentDirectory
let appIconSetDirectory = try generator.createAppIconSet(in: chosenDirectory)
print("Icon set generated: \(appIconSetDirectory.relativePath)")
