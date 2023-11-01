import XCTest
@testable import ImageFeed

final class ProgressTests: XCTestCase {
    func testZero() throws {
        XCTAssertFalse(Progress(from: 0).toHide)
    }

    func testHalf() throws {
        XCTAssertFalse(Progress(from: 0.5).toHide)
    }

    func testFull() throws {
        XCTAssertTrue(Progress(from: 1).toHide)
    }
}
