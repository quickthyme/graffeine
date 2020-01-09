import XCTest
@testable import Graffeine

class GraffeineBarLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeineBarLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.descendingBars) as? GraffeineBarLayer
        sampleData = SampleData()
    }

    func test_bar_layer_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_data_with_11_values_then_it_should_have_11_bar_sublayers() {
        sampleData.applyDescendingBars(to: graffeineView)
        graffeineView.layoutIfNeeded()
        XCTAssertEqual(subject.sublayers!.count, 11)
    }

    func test_given_data_with_11_values_then_it_has_sublayers_positioned_correctly() {
        sampleData.applyDescendingBars(to: graffeineView)
        graffeineView.layoutIfNeeded()
        XCTAssertEqual(normalized(subject.sublayers![ 0].frame), CGRect(x:   0.00, y:  79.00, width: 5.45, height: 79.00))
        XCTAssertEqual(normalized(subject.sublayers![ 1].frame), CGRect(x:  11.45, y:  86.90, width: 5.45, height: 71.10))
        XCTAssertEqual(normalized(subject.sublayers![ 2].frame), CGRect(x:  22.90, y:  94.80, width: 5.45, height: 63.20))
        XCTAssertEqual(normalized(subject.sublayers![ 3].frame), CGRect(x:  34.36, y: 102.70, width: 5.45, height: 55.30))
        XCTAssertEqual(normalized(subject.sublayers![ 4].frame), CGRect(x:  45.81, y: 110.60, width: 5.45, height: 47.40))
        XCTAssertEqual(normalized(subject.sublayers![ 5].frame), CGRect(x:  57.27, y: 118.50, width: 5.45, height: 39.50))
        XCTAssertEqual(normalized(subject.sublayers![ 6].frame), CGRect(x:  68.72, y: 126.40, width: 5.45, height: 31.60))
        XCTAssertEqual(normalized(subject.sublayers![ 7].frame), CGRect(x:   0.00, y:   0.00, width: 1.00, height:  0.00))
        XCTAssertEqual(normalized(subject.sublayers![ 8].frame), CGRect(x:  91.63, y: 142.19, width: 5.45, height: 15.80))
        XCTAssertEqual(normalized(subject.sublayers![ 9].frame), CGRect(x: 103.09, y: 150.10, width: 5.45, height:  7.90))
        XCTAssertEqual(normalized(subject.sublayers![10].frame), CGRect(x: 114.54, y: 158.00, width: 5.45, height:  0.00))
    }
}
