import XCTest
@testable import Graffeine

class GraffeineHorizontalLabelLayerTests: XCTestCase {

    typealias Label = GraffeineHorizontalLabelLayer.Label

    var graffeineView: GraffeineView!
    var subject: GraffeineHorizontalLabelLayer!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    var subjectLabels: [Label] {
        return subject.sublayers!.compactMap { $0 as? Label }
    }

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.bottomGutter) as? GraffeineHorizontalLabelLayer
    }

    func test_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_correct_number_of_labels() {
        let labels = subjectLabels
        XCTAssertEqual(labels.count, 3)
    }

    func test_given_horizontal_alignment_mode_left_when_text_layers_are_positioned_then_they_are_all_left_aligned() {
        subject.labelHorizontalAlignmentMode = .left
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignmentMode, .left)
        XCTAssertEqual(labels[1].alignmentMode, .left)
        XCTAssertEqual(labels.last?.alignmentMode, .left)
    }

    func test_given_label_alignment_mode_right_when_text_layers_are_positioned_then_they_are_all_right_aligned() {
        subject.labelHorizontalAlignmentMode = .right
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignmentMode, .right)
        XCTAssertEqual(labels[1].alignmentMode, .right)
        XCTAssertEqual(labels.last?.alignmentMode, .right)
    }

    func test_given_label_alignment_mode_center_when_text_layers_are_positioned_then_they_are_all_centered() {
        subject.labelHorizontalAlignmentMode = .center
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignmentMode, .center)
        XCTAssertEqual(labels[1].alignmentMode, .center)
        XCTAssertEqual(labels.last?.alignmentMode, .center)
    }

    func test_given_label_alignment_mode_centerLeftRight_when_text_layers_are_positioned_then_it_has_correct_label_alignments() {
        subject.labelHorizontalAlignmentMode = .centerLeftRight
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignmentMode, .left)
        XCTAssertEqual(labels[1].alignmentMode, .center)
        XCTAssertEqual(labels.last?.alignmentMode, .right)
    }

    func test_given_fontSize_when_positioned_then_they_all_have_correct_fontSize_applied() {
        subject.unitText.fontSize = 16
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.fontSize, 16)
        XCTAssertEqual(labels[1].fontSize, 16)
        XCTAssertEqual(labels.last?.fontSize, 16)
    }
}
