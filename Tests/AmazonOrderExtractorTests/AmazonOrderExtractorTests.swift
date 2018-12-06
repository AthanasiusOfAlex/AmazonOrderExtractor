import XCTest
@testable import AmazonOrderExtractor

final class AmazonOrderExtractorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AmazonOrderExtractor().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
