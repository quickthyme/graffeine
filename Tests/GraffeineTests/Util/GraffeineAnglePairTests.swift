import XCTest
@testable import Graffeine

class GRAnglePairTests: XCTestCase {

    var subject: GraffeineAnglePair!

    func test_zero() {
        let subject = GraffeineAnglePair.zero
        XCTAssertEqual(subject.start, 0)
        XCTAssertEqual(subject.end,   0)
    }

    func test_equatable() {
        let subject1 = GraffeineAnglePair(start: 1, end: 1)
        let subject2 = GraffeineAnglePair(start: 1, end: 2)
        let subject3 = GraffeineAnglePair(start: 1, end: 1)

        XCTAssertEqual(subject1, subject3)
        XCTAssertNotEqual(subject1, subject2)
    }

    func test_convert_to_cartesian_coordinate() {
        let subject = GraffeineAnglePair(start: OneDegreeInRadians, end: 2 * OneDegreeInRadians)
        let points = subject.points(center: .zero, radius: 100)
        XCTAssertEqual(normalized(points.start), CGPoint(x: 99.98, y: 1.74))
        XCTAssertEqual(normalized(points.end),   CGPoint(x: 99.93, y: 3.48))
    }
}
