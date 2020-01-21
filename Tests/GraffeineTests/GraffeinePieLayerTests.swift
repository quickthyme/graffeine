import XCTest
@testable import Graffeine

class GraffeinePieLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeinePieLayer!
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
        subject = graffeineView.layer(id: SampleConfig.ID.pie) as? GraffeinePieLayer
        sampleData = SampleData()
    }

    func test_pie_layer_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_explicit_diameter_then_it_should_have_correct_radius() {
        subject.diameter = .explicit(100)
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let slice = subject.sublayers!.first as! GraffeinePieLayer.PieSlice
        XCTAssertEqual(slice.radius, 50)
    }

    func test_given_percent_diameter_then_it_should_have_correct_radius() {
        subject.diameter = .percentage(0.5)
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let slice = subject.sublayers!.first as! GraffeinePieLayer.PieSlice
        XCTAssertEqual(slice.radius, 30)
    }

    func test_given_data_with_3_values_then_it_should_have_3_sublayer_slices() {
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        XCTAssertEqual(subject.sublayers!.count, 3)
    }

    func test_given_data_with_3_values_and_explicit_max_value_then_it_uses_maxValue() {
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let slices = subject.sublayers as! [GraffeinePieLayer.PieSlice]
        XCTAssertEqual(slices.count, 3)
        XCTAssertEqual(radToDeg(slices[0].angles.start),   0.0)
        XCTAssertEqual(radToDeg(slices[0].angles.end),    36.0)

        XCTAssertEqual(radToDeg(slices[1].angles.start),  36.0)
        XCTAssertEqual(radToDeg(slices[1].angles.end),    90.0)

        XCTAssertEqual(radToDeg(slices[2].angles.start),  90.0)
        XCTAssertEqual(radToDeg(slices[2].angles.end),   180.0)
    }

    func test_given_data_with_3_values_and_no_max_value_then_it_uses_sum_of_values() {
        sampleData.applyPieSlicesNoMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let slices = subject.sublayers as! [GraffeinePieLayer.PieSlice]
        XCTAssertEqual(slices.count, 3)
        XCTAssertEqual(radToDeg(slices[0].angles.start),   0.0)
        XCTAssertEqual(radToDeg(slices[0].angles.end),    72.0)

        XCTAssertEqual(radToDeg(slices[1].angles.start),  72.0)
        XCTAssertEqual(radToDeg(slices[1].angles.end),   180.0)

        XCTAssertEqual(radToDeg(slices[2].angles.start), 180.0)
        XCTAssertEqual(radToDeg(slices[2].angles.end),   360.0)
    }
}
