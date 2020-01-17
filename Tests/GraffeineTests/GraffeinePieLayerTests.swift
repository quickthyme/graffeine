import XCTest
@testable import Graffeine

class GraffeinePieLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeinePieLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.pie) as? GraffeinePieLayer
        sampleData = SampleData()
    }

    func test_pie_layer_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_data_with_3_values_then_it_should_have_3_sublayer_slices() {
        sampleData.applyPieSlices(to: graffeineView)
        graffeineView.layoutIfNeeded()
        XCTAssertEqual(subject.sublayers!.count, 3)
    }
}
