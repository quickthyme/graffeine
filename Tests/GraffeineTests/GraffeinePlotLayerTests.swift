import XCTest
@testable import Graffeine

class GraffeinePlotLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeinePlotLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.vectorPlots) as? GraffeinePlotLayer
        sampleData = SampleData()
    }

    func test_plot_layer_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_data_with_7_values_then_it_should_have_7_sublayer_plots() {
        sampleData.applyVectorPlots(to: graffeineView)
        graffeineView.layoutIfNeeded()
        let plots = subject.sublayers as! [GraffeinePlotLayer.Plot]

        XCTAssertEqual(plots.count, 7)
        XCTAssertEqual(normalized(plots[ 0].path!.boundingBoxOfPath), CGRect(x:  -4.00, y: 154.00, width: 8.00, height:  8.00))
        XCTAssertEqual(normalized(plots[ 1].path!.boundingBoxOfPath), CGRect(x:  17.00, y: 146.10, width: 8.00, height:  8.00))
        XCTAssertEqual(normalized(plots[ 2].path!.boundingBoxOfPath), CGRect(x:  38.00, y: 130.30, width: 8.00, height:  8.00))
        XCTAssertEqual(normalized(plots[ 3].path!.boundingBoxOfPath), CGRect(x:  59.00, y: 122.40, width: 8.00, height:  8.00))
        XCTAssertEqual(normalized(plots[ 4].path!.boundingBoxOfPath), CGRect(x:  80.00, y:  75.00, width: 8.00, height:  8.00))
        XCTAssertEqual(normalized(plots[ 5].path!.boundingBoxOfPath), CGRect(x: 101.00, y:  35.50, width: 8.00, height:  8.00))
        XCTAssertEqual(normalized(plots[ 6].path!.boundingBoxOfPath), CGRect(x: 122.00, y:  -4.00, width: 8.00, height:  8.00))
    }
}
