//
//  Created by Simon Kågedal Reimer on 2018-08-22.
//

import AppKit

public enum DrawingCommand: Equatable {
    case fill(color: NSColor)
    case emoji(text: String)
}
