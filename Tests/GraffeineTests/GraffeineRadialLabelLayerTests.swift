import XCTest
@testable import Graffeine

class GraffeineRadialLabelLayerTests: XCTestCase {

    typealias Label = GraffeineRadialLabelLayer.Label

    var graffeineView: GraffeineView!
    var subject: GraffeineRadialLabelLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    var subjectLabels: [Label] {
        return subject.sublayers!.compactMap { $0 as? Label }
    }

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.pieLabels) as? GraffeineRadialLabelLayer
        sampleData = SampleData()
    }

    func test_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_correct_number_of_labels() {
        subject.diameter = .explicit(100)
        sampleData.applyPieSlicesWithMaxValue(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.count, 3)
    }
}
