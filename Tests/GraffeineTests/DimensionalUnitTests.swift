import XCTest
@testable import Graffeine

class DimensionalUnitTests: XCTestCase {

    func test_explicit_sizing() {
        let subject = GraffeineLayer.DimensionalUnit.explicit(10.0)
        let output = subject.resolved(within: 100.0)
        XCTAssertEqual(output, 10.0)
    }

    func test_percentage_sizing() {
        let subject = GraffeineLayer.DimensionalUnit.percentage(0.1)
        let output = subject.resolved(within: 100.0)
        XCTAssertEqual(output, 10.0)
    }

    func test_relative_sizing() {
        let subject = GraffeineLayer.DimensionalUnit.relative
        let output = subject.resolved(within: 100.0,
                                      numberOfUnits: 10,
                                      unitMargin: 1.0)
        XCTAssertEqual(output,  9.1)
    }

    func test_total_possible_from_explicit() {
        let subject = GraffeineLayer.DimensionalUnit.explicit(10.0)
        let output = subject.totalPossible(within: 100.0, unitMargin: 1.0)
        XCTAssertEqual(output, 9)
    }

    func test_total_possible_from_percentage() {
        let subject = GraffeineLayer.DimensionalUnit.percentage(0.2)
        let output = subject.totalPossible(within: 100.0, unitMargin: 0.0)
        XCTAssertEqual(output, 5)
    }
}
