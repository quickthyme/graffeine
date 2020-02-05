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
    }

    func test_given_max_value_20_with_8_values_then_it_should_have_8_grid_lines() {
        XCTAssertEqual(subject.sublayers!.count, 8)
    }

    func test_given_max_value_20_with_values_2_through_18_then_it_has_correct_grid_lines() {
        if let gridLine = (subject.sublayers?[0] as? CAShapeLayer) {
            XCTAssertEqual(gridLine.strokeColor, UIColor.lightGray.cgColor)
            XCTAssertEqual(gridLine.lineDashPattern, [1, 3])
            XCTAssertEqual(gridLine.lineWidth, 0.5)
            XCTAssertEqual(normalized(gridLine.position), CGPoint(x: 60, y: 142.2))
        }

        if let gridLine = (subject.sublayers?[1] as? CAShapeLayer) {
            XCTAssertEqual(gridLine.strokeColor, UIColor.lightGray.cgColor)
            XCTAssertEqual(gridLine.lineDashPattern, [1, 3])
            XCTAssertEqual(gridLine.lineWidth, 0.5)
            XCTAssertEqual(normalized(gridLine.position), CGPoint(x: 60, y: 126.4))
        }

        if let gridLine = (subject.sublayers?[2] as? CAShapeLayer) {
            XCTAssertEqual(gridLine.strokeColor, UIColor.lightGray.cgColor)
            XCTAssertEqual(gridLine.lineDashPattern, [1, 3])
            XCTAssertEqual(gridLine.lineWidth, 0.5)
            XCTAssertEqual(normalized(gridLine.position), CGPoint(x: 60, y: 110.6))
        }

        if let gridLine = (subject.sublayers?[3] as? CAShapeLayer) {
            XCTAssertEqual(gridLine.strokeColor, UIColor.lightGray.cgColor)
            XCTAssertEqual(gridLine.lineDashPattern, [1, 3])
            XCTAssertEqual(gridLine.lineWidth, 0.5)
            XCTAssertEqual(normalized(gridLine.position), CGPoint(x: 60, y: 94.8))
        }

        if let gridLine = (subject.sublayers?[4] as? CAShapeLayer) {
            XCTAssertEqual(gridLine.strokeColor, UIColor.lightGray.cgColor)
            XCTAssertEqual(gridLine.lineDashPattern, [1, 3])
            XCTAssertEqual(gridLine.lineWidth, 0.5)
            XCTAssertEqual(normalized(gridLine.position), CGPoint(x: 60, y: 63.2))
        }

        if let gridLine = (subject.sublayers?[5] as? CAShapeLayer) {
            XCTAssertEqual(gridLine.strokeColor, UIColor.lightGray.cgColor)
            XCTAssertEqual(gridLine.lineDashPattern, [1, 3])
            XCTAssertEqual(gridLine.lineWidth, 0.5)
            XCTAssertEqual(normalized(gridLine.position), CGPoint(x: 60, y: 47.4))
        }

        if let gridLine = (subject.sublayers?[6] as? CAShapeLayer) {
            XCTAssertEqual(gridLine.strokeColor, UIColor.lightGray.cgColor)
            XCTAssertEqual(gridLine.lineDashPattern, [1, 3])
            XCTAssertEqual(gridLine.lineWidth, 0.5)
            XCTAssertEqual(normalized(gridLine.position), CGPoint(x: 60, y: 31.59))
        }

        if let gridLine = (subject.sublayers?[7] as? CAShapeLayer) {
            XCTAssertEqual(gridLine.strokeColor, UIColor.lightGray.cgColor)
            XCTAssertEqual(gridLine.lineDashPattern, [1, 3])
            XCTAssertEqual(gridLine.lineWidth, 0.5)
            XCTAssertEqual(normalized(gridLine.position), CGPoint(x: 60, y: 15.79))
        }
    }
}
