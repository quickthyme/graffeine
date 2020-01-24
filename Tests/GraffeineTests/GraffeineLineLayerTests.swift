import XCTest
@testable import Graffeine

class GraffeineLineLayerTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeineLineLayer!
    var sampleData: SampleData!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.greenLine) as? GraffeineLineLayer
        sampleData = SampleData()
    }

    func test_line_layer_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_data_with_11_values_then_it_should_have_1_sublayer_line() {
        sampleData.applyGreenLine(to: graffeineView)
        graffeineView.layoutIfNeeded()
        XCTAssertEqual(subject.sublayers!.count, 1)
    }

    func test_line_properties_pass_through_to_line_shape_layer() {
        sampleData.applyGreenLine(to: graffeineView)
        subject.apply {
            $0.unitLine.thickness = 10
            $0.unitLine.dashPattern = [2, 4]
            $0.unitLine.dashPhase = 2
            $0.unitLine.join = .round
            $0.unitLine.cap = .square
        }
        graffeineView.layoutIfNeeded()
        let lineShape = subject.sublayers!.first as! GraffeineLineLayer.Line
        XCTAssertEqual(lineShape.lineWidth, 10)
        XCTAssertEqual(lineShape.lineDashPattern, [2, 4])
        XCTAssertEqual(lineShape.lineDashPhase,  2)
        XCTAssertEqual(lineShape.lineJoin, .round)
        XCTAssertEqual(lineShape.lineCap, .square)
    }

    func test_line_smoothing_applies_to_line_shape_layer() {
        sampleData.applyGreenLine(to: graffeineView)
        subject.apply {
            $0.unitLine.join = .round
            $0.smoothing = .catmullRom(6)
        }
        graffeineView.layoutIfNeeded()
        let lineShape = subject.sublayers!.first as! GraffeineLineLayer.Line
        let linePath = UIBezierPath.init(cgPath: lineShape.path!)
        let testMethod = TestSmoothingMethod()
        let linePoints = testMethod.extractPoints(from: linePath)
        XCTAssertEqual(linePoints.count, 62)
    }
}

extension GraffeineLineLayerTests {

    class TestSmoothingMethod: LineSmoothingMethod {
        func pathBySmoothing(in path: UIBezierPath) -> UIBezierPath {
            return path
        }
    }
}
