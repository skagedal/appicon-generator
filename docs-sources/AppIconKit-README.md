# AppIconKit

This is a framework that supports the [appicon-generator](https://github.com/skagedal/appicon-generator/) tool. It can also be used independently. Using Swift Package Manager, your package definition may look a little something like this:

```swift
let package = Package(
    name: "my-tool",
    dependencies: [
        .package(url: "https://github.com/skagedal/appicon-generator/", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "my-tool",
            dependencies: ["AppIconGeneratorCore"])
    ]
)
```

Then you can import the framework in your code.

```swift
import AppIconKit
```

You use `EmojiIconRenderer` to render a single emoji icon as a PNG.

```swift
let iconRenderer = EmojiIconRenderer(text: "😺", backgroundColor: .white)
let data = try iconRenderer.renderPNG(sizeInPixels: 50)
```

You can also use it in combination with `AppIconSetGenerator` to generate a full set of icons.

```swift
let generator = AppIconSetGenerator(iconRenderer: iconRenderer)
let currentDirectory = URL(fileURLWithPath: "")
try generator.createAppIconSet(in: currentDirectory)
```

You can also pass in your own icon renderer by conforming to the `IconRenderer` protocol.
