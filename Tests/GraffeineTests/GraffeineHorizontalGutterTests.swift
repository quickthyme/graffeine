import XCTest
@testable import Graffeine

class GraffeineHorizontalGutterTests: XCTestCase {

    var graffeineView: GraffeineView!
    var subject: GraffeineHorizontalGutter!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 200)

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.bottomGutter) as? GraffeineHorizontalGutter
    }

    func test_bar_layer_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_given_label_alignment_mode_left_when_text_layers_are_positioned_then_they_are_all_left_aligned() {
        subject.labelAlignmentMode = .left
        graffeineView.layoutIfNeeded()
        let labels = subject.sublayers!.compactMap { $0 as? GraffeineHorizontalGutter.Label }
        XCTAssertEqual(labels.count, 3)
        XCTAssertEqual(labels[0].alignmentMode, .left)
        XCTAssertEqual(labels[1].alignmentMode, .left)
        XCTAssertEqual(labels[2].alignmentMode, .left)
    }

    func test_given_label_alignment_mode_right_when_text_layers_are_positioned_then_they_are_all_right_aligned() {
        subject.labelAlignmentMode = .right
        graffeineView.layoutIfNeeded()
        let labels = subject.sublayers!.compactMap { $0 as? GraffeineHorizontalGutter.Label }
        XCTAssertEqual(labels.count, 3)
        XCTAssertEqual(labels[0].alignmentMode, .right)
        XCTAssertEqual(labels[1].alignmentMode, .right)
        XCTAssertEqual(labels[2].alignmentMode, .right)
    }

    func test_given_label_alignment_mode_center_when_text_layers_are_positioned_then_they_are_all_centered() {
        subject.labelAlignmentMode = .center
        graffeineView.layoutIfNeeded()
        let labels = subject.sublayers!.compactMap { $0 as? GraffeineHorizontalGutter.Label }
        XCTAssertEqual(labels.count, 3)
        XCTAssertEqual(labels[0].alignmentMode, .center)
        XCTAssertEqual(labels[1].alignmentMode, .center)
        XCTAssertEqual(labels[2].alignmentMode, .center)
    }

    func test_given_label_alignment_mode_centerLeftRight_when_text_layers_are_positioned_then_it_has_correct_label_alignments() {
        subject.labelAlignmentMode = .centerLeftRight
        graffeineView.layoutIfNeeded()
        let labels = subject.sublayers!.compactMap { $0 as? GraffeineHorizontalGutter.Label }
        XCTAssertEqual(labels.count, 3)
        XCTAssertEqual(labels[0].alignmentMode, .left)
        XCTAssertEqual(labels[1].alignmentMode, .center)
        XCTAssertEqual(labels[2].alignmentMode, .right)
    }
}
