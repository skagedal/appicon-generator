//
//  Copyright © 2019 Simon Kågedal Reimer. See LICENSE.
//

import AppKit

public enum DrawingCommand: Equatable {
    case fill(color: NSColor)
    case emoji(text: String)
}
