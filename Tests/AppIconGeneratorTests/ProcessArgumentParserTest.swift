import XCTest
import AppIconKit
import AppIconGeneratorCore

class ProcessArgumentParserTest: XCTestCase {
    let parser = ProcessArgumentParser()

    func testFailedParsing() throws {
        // Actually if there isn't even one element (the script name) in the array it's more of a programmer error / fatal error
        XCTAssertThrowsError(try parser.parse([]), "Should throw error")
        XCTAssertThrowsError(try parser.parse([""]), "Should throw error")
    }
    
    func testSimpleParsing() throws {
        let p = try parser.parse(["", "😺"])
        XCTAssertEqual(p.drawingCommands, [DrawingCommand.emoji(text: "😺")])
        // When no idiom is passed, we expect both
        XCTAssertTrue(p.idioms.contains(AppIconIdioms.iPad))
        XCTAssertTrue(p.idioms.contains(AppIconIdioms.iPhone))
    }
    
    func testIpadParsing() throws {
        let p = try parser.parse(["", "--ipad", "😺"])
        XCTAssertEqual(p.drawingCommands, [DrawingCommand.emoji(text: "😺")])
        XCTAssertTrue(p.idioms.contains(AppIconIdioms.iPad))
        XCTAssertFalse(p.idioms.contains(AppIconIdioms.iPhone))
    }

    func testIphoneParsing() throws {
        let p = try parser.parse(["", "--iphone", "😺"])
        XCTAssertEqual(p.drawingCommands, [DrawingCommand.emoji(text: "😺")])
        XCTAssertFalse(p.idioms.contains(AppIconIdioms.iPad))
        XCTAssertTrue(p.idioms.contains(AppIconIdioms.iPhone))
    }

}
