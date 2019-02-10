import XCTest
import AppIconKit
import AppIconGeneratorCore

private func parse(_ arguments: [String]) throws -> ProcessArguments {
    return try ProcessArguments(arguments: arguments)
}

class ProcessArgumentParserTest: XCTestCase {
    func testSimpleParsing() throws {
        let p = try parse(["", "😺"])
        XCTAssertEqual(p.drawingCommands, [DrawingCommand.emoji(text: "😺")])
        // When no idiom is passed, we expect both
        XCTAssertTrue(p.idioms.contains(AppIconIdioms.iPad))
        XCTAssertTrue(p.idioms.contains(AppIconIdioms.iPhone))
        XCTAssertFalse(p.showHelp)
        XCTAssertFalse(p.showVersion)
    }
    
    func testIpadParsing() throws {
        let p = try parse(["", "--ipad", "😺"])
        XCTAssertEqual(p.drawingCommands, [DrawingCommand.emoji(text: "😺")])
        XCTAssertTrue(p.idioms.contains(AppIconIdioms.iPad))
        XCTAssertFalse(p.idioms.contains(AppIconIdioms.iPhone))
    }

    func testIphoneParsing() throws {
        let p = try parse(["", "--iphone", "😺"])
        XCTAssertEqual(p.drawingCommands, [DrawingCommand.emoji(text: "😺")])
        XCTAssertFalse(p.idioms.contains(AppIconIdioms.iPad))
        XCTAssertTrue(p.idioms.contains(AppIconIdioms.iPhone))
    }

    func testHelpAndVersion() throws {
        let help = try parse(["", "--help"])
        XCTAssertTrue(help.showHelp)
        XCTAssertFalse(help.showVersion)
        
        let version = try parse(["", "--version"])
        XCTAssertTrue(version.showVersion)
        XCTAssertFalse(version.showHelp)
    }
}
