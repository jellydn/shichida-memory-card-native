import XCTest
@testable import ShichidaMemoryCards

final class CardSequenceTests: XCTestCase {
    func testSequenceStopsAtBothEnds() {
        var sequence = CardSequence(count: 3)

        sequence.goBack()
        XCTAssertEqual(sequence.index, 0)

        sequence.goForward()
        sequence.goForward()
        sequence.goForward()
        XCTAssertEqual(sequence.index, 2)
        XCTAssertFalse(sequence.canGoForward)

        sequence.goBack()
        XCTAssertEqual(sequence.index, 1)
    }

    func testSingleCardCannotMove() {
        var sequence = CardSequence(count: 1)

        sequence.goBack()
        sequence.goForward()

        XCTAssertEqual(sequence.index, 0)
        XCTAssertFalse(sequence.canGoBack)
        XCTAssertFalse(sequence.canGoForward)
    }
}
