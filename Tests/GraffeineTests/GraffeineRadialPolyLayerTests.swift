import XCTest
@testable import Graffeine

class GraffeineRadialPolyLayerTests: XCTestCase {

    typealias Polygon = GraffeineRadialPolyLayer.Polygon

    var graffeineView: GraffeineView!
    var subject: GraffeineRadialPolyLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    var subjectPolygon: Polygon? {
        return subject.sublayers?.first as? Polygon
    }

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.radar) as? GraffeineRadialPolyLayer
        sampleData = SampleData()
    }

    func test_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_some_data_when_rendered_then_it_is_roughly_the_right_size() {
        subject.maxDiameter = .explicit(100)
        sampleData.applyRadarValues(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let polygon = subjectPolygon
        XCTAssertEqual(normalized(polygon!.path!.boundingBox.size.width),  37.5)
        XCTAssertEqual(normalized(polygon!.path!.boundingBox.size.height), 43.3)
    }
}
