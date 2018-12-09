import XCTest
@testable import AmazonOrderExtractor

final class AmazonOrderExtractorTests: XCTestCase {
    func testExample() {
        _ = getReceiptMessages().map { print($0.subject!) }
        //openLinksInChrome()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
