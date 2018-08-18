import AppKit

guard let text = ProcessInfo.processInfo.arguments.dropFirst().first else {
    print("Please call with the text for the icon as an argument")
    exit(1)
}

let renderer = IconRenderer(text: text, backgroundColor: .white)
let data = try renderer.render(sizeInPixels: 100)
try data.write(to: URL(fileURLWithPath: "icon100.png"))

let generator = AppIconSetGenerator(iconRenderer: renderer)
let currentDirectory = URL(fileURLWithPath: "")
try generator.createAppIconSet(in: currentDirectory)
