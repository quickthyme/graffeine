import XCTest
@testable import Graffeine

class GraffeineVerticalLabelLayerTests: XCTestCase {

    typealias Label = GraffeineVerticalLabelLayer.Label

    var graffeineView: GraffeineView!
    var subject: GraffeineVerticalLabelLayer!

    let graffeineViewFrame = CGRect(x: 0, y: 0, width: 200, height: 300)

    var subjectLabels: [Label] {
        return subject.sublayers!.compactMap { $0 as? Label }
    }

    override func setUp() {
        graffeineView = GraffeineView(frame: graffeineViewFrame)
        let _ = SampleConfig(graffeineView)
        subject = graffeineView.layer(id: SampleConfig.ID.leftGutter) as? GraffeineVerticalLabelLayer
    }

    func test_loaded_properly() {
        XCTAssertNotNil(subject)
    }

    func test_correct_number_of_labels() {
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.count, 11)
    }

    func test_given_horizontal_alignment_mode_left_when_positioned_then_they_are_all_left_aligned() {
        subject.labelAlignment.horizontal = .left
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignment.horizontal, .left)
        XCTAssertEqual(labels[1].alignment.horizontal, .left)
        XCTAssertEqual(labels.last?.alignment.horizontal, .left)
    }

    func test_given_label_alignment_mode_right_when_positioned_then_they_are_all_right_aligned() {
        subject.labelAlignment.horizontal = .right
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignment.horizontal, .right)
        XCTAssertEqual(labels[1].alignment.horizontal, .right)
        XCTAssertEqual(labels.last?.alignment.horizontal, .right)
    }

    func test_given_label_alignment_mode_center_when_positioned_then_they_are_all_centered() {
        subject.labelAlignment.horizontal = .center
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignment.horizontal, .center)
        XCTAssertEqual(labels[1].alignment.horizontal, .center)
        XCTAssertEqual(labels.last?.alignment.horizontal, .center)
    }

    func test_given_label_alignment_mode_centerLeftRight_when_positioned_then_it_has_correct_label_alignments() {
        subject.labelAlignment.horizontal = .centerLeftRight
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignment.horizontal, .left)
        XCTAssertEqual(labels[1].alignment.horizontal, .center)
        XCTAssertEqual(labels.last?.alignment.horizontal, .right)
    }

    func test_given_vertical_alignment_mode_top_when_positioned_then_they_are_all_aligned_top() {
        subject.labelAlignment.vertical = .top
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignment.vertical, .top)
        XCTAssertEqual(labels[1].alignment.vertical, .top)
        XCTAssertEqual(labels.last?.alignment.vertical, .top)
    }

    func test_given_vertical_alignment_mode_bottom_when_positioned_then_they_are_all_aligned_bottom() {
        subject.labelAlignment.vertical = .bottom
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignment.vertical, .bottom)
        XCTAssertEqual(labels[1].alignment.vertical, .bottom)
        XCTAssertEqual(labels.last?.alignment.vertical, .bottom)
    }

    func test_given_vertical_alignment_mode_center_when_positioned_then_they_are_all_aligned_center() {
        subject.labelAlignment.vertical = .center
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignment.vertical, .center)
        XCTAssertEqual(labels[1].alignment.vertical, .center)
        XCTAssertEqual(labels.last?.alignment.vertical, .center)
    }

    func test_given_vertical_alignment_mode_centerTopBottom_when_positioned_then_they_are_correct() {
        subject.labelAlignment.vertical = .centerTopBottom
        graffeineView.layoutIfNeeded()
        let labels = subjectLabels
        XCTAssertEqual(labels.first?.alignment.vertical, .top)
        XCTAssertEqual(labels[1].alignment.vertical, .center)
        XCTAssertEqual(labels.last?.alignment.vertical, .bottom)
    }
}
