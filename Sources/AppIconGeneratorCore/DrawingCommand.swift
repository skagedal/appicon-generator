import AppKit

public enum DrawingCommand: Equatable {
    case fill(color: NSColor)
    case emoji(text: String)
}
