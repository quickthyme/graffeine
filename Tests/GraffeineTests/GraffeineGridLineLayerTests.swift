import XCTest
@testable import Graffeine

class GraffeineGridLineLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeineGridLineLayer!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.bgGrid) as? GraffeineGridLineLayer
        graffeineView.layoutIfNeeded()
    }

    func test_grid_layer_loaded_properly() {
        XCTAssertNotNil(subject)
        XCTAssertEqual(subject.sublayers!.count, 8)
    }
}
