import XCTest
@testable import Graffeine

class GraffeineBarLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeineBarLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    func boundingBox(_ bar: GraffeineBarLayer.Bar) -> CGRect {
        return bar.path?.boundingBoxOfPath ?? .zero
    }

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
        let bars = subject.sublayers as! [GraffeineBarLayer.Bar]
        XCTAssertEqual(normalized(boundingBox(bars[ 0])), CGRect(x:   0.00, y:  79.00, width: 5.45, height: 79.00))
        XCTAssertEqual(normalized(boundingBox(bars[ 1])), CGRect(x:  11.45, y:  86.90, width: 5.45, height: 71.10))
        XCTAssertEqual(normalized(boundingBox(bars[ 2])), CGRect(x:  22.90, y:  94.80, width: 5.45, height: 63.20))
        XCTAssertEqual(normalized(boundingBox(bars[ 3])), CGRect(x:  34.36, y: 102.70, width: 5.45, height: 55.30))
        XCTAssertEqual(normalized(boundingBox(bars[ 4])), CGRect(x:  45.81, y: 110.60, width: 5.45, height: 47.40))
        XCTAssertEqual(normalized(boundingBox(bars[ 5])), CGRect(x:  57.27, y: 118.50, width: 5.45, height: 39.50))
        XCTAssertEqual(normalized(boundingBox(bars[ 6])), CGRect(x:  68.72, y: 126.40, width: 5.45, height: 31.59))
        XCTAssertEqual(normalized(boundingBox(bars[ 7])), CGRect(x:  80.18, y: 158.00, width: 5.45, height:  0.00))
        XCTAssertEqual(normalized(boundingBox(bars[ 8])), CGRect(x:  91.63, y: 142.19, width: 5.45, height: 15.80))
        XCTAssertEqual(normalized(boundingBox(bars[ 9])), CGRect(x: 103.09, y: 150.10, width: 5.45, height:  7.90))
        XCTAssertEqual(normalized(boundingBox(bars[10])), CGRect(x: 114.54, y: 158.00, width: 5.45, height:  0.00))
    }

    func test_given_subdivision_present_then_it_has_sublayers_positioned_correctly() {
        subject.unitSubdivision.offset = .percentage(0.33)
        subject.unitSubdivision.width = .percentage(0.33)
        sampleData.applyDescendingBars(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let bars = subject.sublayers as! [GraffeineBarLayer.Bar]
        XCTAssertEqual(normalized(boundingBox(bars[ 0])), CGRect(x:   1.80, y:  79.00, width: 1.80, height: 79.00))
        XCTAssertEqual(normalized(boundingBox(bars[ 1])), CGRect(x:  13.25, y:  86.90, width: 1.80, height: 71.10))
        XCTAssertEqual(normalized(boundingBox(bars[ 2])), CGRect(x:  24.70, y:  94.80, width: 1.80, height: 63.20))
        XCTAssertEqual(normalized(boundingBox(bars[ 3])), CGRect(x:  36.16, y: 102.70, width: 1.79, height: 55.30))
        XCTAssertEqual(normalized(boundingBox(bars[ 4])), CGRect(x:  47.61, y: 110.60, width: 1.79, height: 47.40))
        XCTAssertEqual(normalized(boundingBox(bars[ 5])), CGRect(x:  59.07, y: 118.50, width: 1.79, height: 39.50))
        XCTAssertEqual(normalized(boundingBox(bars[ 6])), CGRect(x:  70.52, y: 126.40, width: 1.79, height: 31.59))
        XCTAssertEqual(normalized(boundingBox(bars[ 7])), CGRect(x:  81.98, y: 158.00, width: 1.79, height:  0.00))
        XCTAssertEqual(normalized(boundingBox(bars[ 8])), CGRect(x:  93.43, y: 142.19, width: 1.79, height: 15.80))
        XCTAssertEqual(normalized(boundingBox(bars[ 9])), CGRect(x: 104.89, y: 150.10, width: 1.79, height:  7.90))
        XCTAssertEqual(normalized(boundingBox(bars[10])), CGRect(x: 116.34, y: 158.00, width: 1.79, height:  0.00))
    }

    func test_given_unit_shadow_values_then_it_has_sublayers_with_individual_shadow() {
        sampleData.applyDescendingBars(to: graffeineView)
        subject.unitShadow.color = .red
        subject.unitShadow.offset = CGSize(width: 2, height: 3)
        subject.unitShadow.opacity = 0.6
        subject.unitShadow.radius = 3
        graffeineView.layoutIfNeeded()
        let bars = subject.sublayers as! [GraffeineBarLayer.Bar]
        XCTAssertEqual(bars.first!.shadowColor, UIColor.red.cgColor)
        XCTAssertEqual(bars.first!.shadowOffset, CGSize(width: 2, height: 3))
        XCTAssertEqual(bars.first!.shadowOpacity, 0.6)
        XCTAssertEqual(bars.first!.shadowRadius, 3)
    }
}
