import XCTest
@testable import Graffeine

class GraffeineRadialSegmentLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeineRadialSegmentLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    private func degToRad(_ deg: CGFloat) -> CGFloat {
        return deg * (CGFloat.pi / 180)
    }
    private func radToDeg(_ rad: CGFloat) -> CGFloat {
        return rad * 180 / .pi
    }

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.pie) as? GraffeineRadialSegmentLayer
        sampleData = SampleData()
    }

    func test_pie_layer_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_explicit_outer_diameter_then_it_should_have_correct_outer_radius() {
        subject.outerDiameter = .explicit(100)
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let slice = subject.sublayers!.first as! GraffeineRadialSegmentLayer.Segment
        XCTAssertEqual(slice.outerRadius, 50)
    }

    func test_given_percent_outer_diameter_then_it_should_have_correct_outer_radius() {
        subject.outerDiameter = .percentage(0.5)
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let slice = subject.sublayers!.first as! GraffeineRadialSegmentLayer.Segment
        XCTAssertEqual(slice.outerRadius, 30)
    }

    func test_given_data_with_3_values_then_it_should_have_3_segments() {
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        XCTAssertEqual(subject.sublayers!.count, 3)
    }

    func test_given_data_with_3_values_and_explicit_max_value_then_it_uses_maxValue() {
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let slices = subject.sublayers as! [GraffeineRadialSegmentLayer.Segment]
        XCTAssertEqual(slices.count, 3)
        XCTAssertEqual(radToDeg(slices[0].angles.start),   0.0)
        XCTAssertEqual(radToDeg(slices[0].angles.end),    36.0)

        XCTAssertEqual(radToDeg(slices[1].angles.start),  36.0)
        XCTAssertEqual(radToDeg(slices[1].angles.end),    90.0)

        XCTAssertEqual(radToDeg(slices[2].angles.start),  90.0)
        XCTAssertEqual(radToDeg(slices[2].angles.end),   180.0)
    }

    func test_given_data_with_no_max_value_then_it_uses_sum_of_values() {
        sampleData.applyPieSlicesNoMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let slices = subject.sublayers as! [GraffeineRadialSegmentLayer.Segment]
        XCTAssertEqual(slices.count, 3)
        XCTAssertEqual(radToDeg(slices[0].angles.start),   0.0)
        XCTAssertEqual(radToDeg(slices[0].angles.end),    72.0)

        XCTAssertEqual(radToDeg(slices[1].angles.start),  72.0)
        XCTAssertEqual(radToDeg(slices[1].angles.end),   180.0)

        XCTAssertEqual(radToDeg(slices[2].angles.start), 180.0)
        XCTAssertEqual(radToDeg(slices[2].angles.end),   360.0)
    }
}
